require 'httpparty'

module ChatsHelper
    def get_chat_examples
        return [
            "What is your name?",
            "What is your quest?",
            "What is the air-speed velocity of an unladen swallow?"
        ]
    end

    def ask_question
        server = ENV["OPENAI_SERVER"] || "http://localhost:1234"
        model = ENV["OPENAI_MODEL_ID"] || 'hi-tinylama'
        api_key = ENV["OPENAI_API_KEY"] || ""
        temperature = 0

        url = server + "/v1/chat/completions"
        body = {
            "model" => model,
            "messages" => @chat.messages.map{
                |m| { "role" => m.role, "content": m.value }
            },
            "temperature" => temperature,
            "stream" => false
        }
        # TODO: add gracefull failure blocks here: begin...
        # Add rescue blocks to catch network and HTTP exceptions such as HTTParty::Error, Net::TimeoutError, SocketError, and OpenSSL::SSL::SSLError
        res = HTTParty.post(
            url,
            :body=>body.to_json,
            :headers => {'Content-Type' => 'application/json', 'Authorization' => "Bearer #{api_key}"}
        )
        puts "RESPONSE"
        puts res.body
        json_resp = hash = JSON.parse(res.body)
        message_data = json_resp['choices'][0]["message"]
        @chat.messages << Message.new(role: message_data["role"], value: message_data["content"])
    end
end
