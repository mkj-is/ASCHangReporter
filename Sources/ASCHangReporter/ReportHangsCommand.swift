//
//  File.swift
//  
//
//  Created by Matěj Kašpar Jirásek on 09.01.2023.
//

import Foundation
import ArgumentParser
import AppStoreConnect_Swift_SDK

enum ReportHangsError: Error {
    case appNotFound
    case buildNotFound
}

@main
struct ReportHangsCommand: AsyncParsableCommand {

    @Argument(help: "Key ID")
    private var keyID: String

    @Argument(help: "Issuer ID")
    private var issuerID: String

    @Argument(help: "Private key")
    private var privateKey: String

    @Argument(help: "Bundle identifier")
    private var bundleIdentifier: String?

    func run() async throws {
        let configuration = APIConfiguration(issuerID: issuerID, privateKeyID: keyID, privateKey: privateKey)
        let provider = APIProvider(configuration: configuration)

        let filterBundleID = bundleIdentifier.flatMap { [$0] }
        let appsRequest = APIEndpoint
            .v1
            .apps
            .get(parameters: APIEndpoint.V1.Apps.GetParameters(filterBundleID: filterBundleID, limit: 1))

        guard let appId = try await provider.request(appsRequest).data.first?.id else {
            throw ReportHangsError.appNotFound
        }

        let versionsRequest = APIEndpoint
            .v1
            .apps
            .id(appId)
            .appStoreVersions
            .get(parameters: APIEndpoint.V1.Apps.WithID.AppStoreVersions.GetParameters(
                filterAppStoreState: [.readyForSale, .replacedWithNewVersion],
                include: [.build]
            ))

        for try await response in provider.paged(versionsRequest) {
            for version in response.data {
                if let buildId = version.relationships?.build?.data?.id {
                    let hangRequest = APIEndpoint
                        .v1
                        .builds
                        .id(buildId)
                        .diagnosticSignatures
                        .get(parameters: APIEndpoint.V1.Builds.WithID.DiagnosticSignatures.GetParameters(
                            filterDiagnosticType: [.hangs]
                        ))

                    let percentageFormatter = NumberFormatter()
                    percentageFormatter.numberStyle = .percent

                    for try await response in provider.paged(hangRequest) {
                        for hang in response.data {

                            let weight = hang.attributes?.weight ?? 0.0
                            print("- Signature: \(hang.attributes?.signature ?? "—")")
                            print("- Weight: \(percentageFormatter.string(from: weight as NSNumber) ?? "—")")
                            print("- App version: \(version.attributes?.versionString ?? "—")")
                            print("- Hang ID: \(hang.id)")
                            print("")
                        }
                    }
                }
                print("")
            }
        }
    }
}
