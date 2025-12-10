//
//  ViewController.swift
//  joi
//
//  Created by Isaac Huntsman on 12/8/25.
//

import Foundation

struct LLMConfig: Codable {
    let url: String
    let api_key: String
    let system_messages: [SystemMessage]
    let greeting_message: String
    let failure_message: String
    let max_history: Int
    let params: [String: String]
}

struct SystemMessage: Codable {
    let role: String
    let content: String
}

struct TTSParams: Codable {
    let key: String
    let model_id: String
    let voice_id: String
    let sample_rate: Int
}

struct TTSConfig: Codable {
    let vendor: String
    let params: TTSParams
}

struct ASRConfig: Codable {
    let language: String
}

struct AgentProperties: Codable {
    let channel: String
    let token: String
    let agent_rtc_uid: String
    let remote_rtc_uids: [String]
    let enable_string_uid: Bool
    let idle_timeout: Int
    let llm: LLMConfig
    let asr: ASRConfig
    let tts: TTSConfig
}

struct JoinRequestBody: Codable {
    let name: String
    let properties: AgentProperties
}

struct JoinResponse: Codable {
    let agent_id: String
    let create_ts: Int
    let status: String
}

let agoraBaseUrl = Bundle.main.object(forInfoDictionaryKey: "AGORA_BASE_URL") as? String
let llmBaseUrl = Bundle.main.object(forInfoDictionaryKey: "LLM_BASE_URL") as? String
let llmApiKey = Bundle.main.object(forInfoDictionaryKey: "LLM_API_KEY") as? String
let ttsVendor = Bundle.main.object(forInfoDictionaryKey: "TTS_VENDOR") as? String
let ttsApiKey = Bundle.main.object(forInfoDictionaryKey: "TTS_API_KEY") as? String
let ttsModelId = Bundle.main.object(forInfoDictionaryKey: "TTS_MODEL_ID") as? String
let ttsVoiceId = Bundle.main.object(forInfoDictionaryKey: "TTS_VOICE_ID") as? String
let llmModelId = Bundle.main.object(forInfoDictionaryKey: "LLM_MODEL_ID") as? String


final class AgoraAPIClient {

    private let appId: String
    private let authHeader: String
    private let baseURL = agoraBaseUrl!

    init(appId: String, base64Credentials: String) {
        self.appId = appId
        self.authHeader = "Basic \(base64Credentials)"
    }

    func joinAgent(
        channel: String,
        token: String,
        completion: @escaping (Result<JoinResponse, Error>) -> Void
    ) {
        let urlString = "\(baseURL)/projects/\(appId)/join"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "AgoraAPIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Same payload as in example from Agora docs
        let body = JoinRequestBody(
            name: "unique_name",
            properties: AgentProperties(
                channel: channel,
                token: token,
                agent_rtc_uid: "0",
                remote_rtc_uids: ["1002"],
                enable_string_uid: false,
                idle_timeout: 120,
                llm: LLMConfig(
                    url: llmBaseUrl!,
                    api_key: llmApiKey!,
                    system_messages: [
                        SystemMessage(role: "system", content: "You are a helpful chatbot.")
                    ],
                    greeting_message: "Hello, how can I help you?",
                    failure_message: "Sorry, I don't know how to answer this question.",
                    max_history: 10,
                    params: [
                        "model": llmModelId!
                    ]
                ),
                asr: ASRConfig(language: "en-US"),
                tts: TTSConfig(
                  vendor: ttsVendor!,
                  params: TTSParams(
                    key: ttsApiKey!,
                    model_id: ttsModelId!,
                    voice_id: ttsVoiceId!,
                    sample_rate: 24000
                  )
                )
            )
        )
            

        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data = data else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let err = NSError(domain: "AgoraAPIClient", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad response \(statusCode)"])
                completion(.failure(err))
                return
            }

            do {
                let decoder = JSONDecoder()
                let joinResponse = try decoder.decode(JoinResponse.self, from: data)
                completion(.success(joinResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
