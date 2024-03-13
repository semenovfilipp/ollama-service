import com.mlp.sdk.MlpExecutionContext
import com.mlp.sdk.MlpPredictServiceBase
import com.mlp.sdk.MlpServiceSDK
import com.mlp.sdk.datatypes.chatgpt.*
import com.mlp.sdk.utils.JSON
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException
import java.util.concurrent.TimeUnit

/// OLLAMA DATA
data class OllamaRequest(
    val model: String,
    val prompt: String,
    val stream: Boolean
)

data class OllamaResponse(
    val model: String,
    val created_at: String,
    val response: String,
    val done: Boolean,
    val context: List<Int>,
    val totalDuration: Long,
    val loadDuration: Long,
    val promptEvalCount: Int,
    val promptEvalDuration: Long,
    val evalCount: Int,
    val evalDuration: Long
)


class OllamaService(
    override val context: MlpExecutionContext
) : MlpPredictServiceBase<ChatCompletionRequest, ChatCompletionResult>(
    REQUEST_EXAMPLE,
    RESPONSE_EXAMPLE
) {
    private val MEDIA_TYPE_JSON = "application/json".toMediaType()
    private val httpClient = OkHttpClient.Builder()
        .readTimeout(120, TimeUnit.SECONDS)
        .writeTimeout(120,TimeUnit.SECONDS)
        .connectTimeout(120,TimeUnit.SECONDS)
        .build()

    private val URL = "http://localhost:11434/api/generate"




    override fun predict(req: ChatCompletionRequest): ChatCompletionResult {
        val olamaRequest = toOlamaRequest(req)
        val olamaResponse = sendMessageToOllama(olamaRequest)
        return toChatResult(olamaResponse)
    }



    fun sendMessageToOllama(request: OllamaRequest): OllamaResponse {
        val request = Request.Builder()
            .url(URL)
            .post(JSON.stringify(request).toRequestBody(MEDIA_TYPE_JSON))
            .build()

        val response = httpClient.newCall(request).execute()
        if (!response.isSuccessful) {
            throw IOException("Unexpected code ${response.code}")
        }
        return JSON.parse(response.body!!.string(), OllamaResponse::class.java)
    }

    /*
  * Request в Ollama из Caila
  */
    fun toOlamaRequest(req: ChatCompletionRequest): OllamaRequest {
        return OllamaRequest(
            model = req.model ?: "llama2",
            prompt = req.messages.first().content,
            stream = false
        )
    }

    /*
     * Response из Ollama и передача его в Caila
     */

    fun toChatResult(res: OllamaResponse): ChatCompletionResult {
        return ChatCompletionResult(
            created = 0L,
            model = res.model,
            choices = listOf(
                ChatCompletionChoice(
                    index = 0,
                    message = ChatMessage(
                        role = ChatCompletionRole.user,
                        content = res.response
                    )
                )
            ),
        )
    }


    /*
     * Пример запроса к модели
     */
    companion object {
        val REQUEST_EXAMPLE = ChatCompletionRequest(
            messages = listOf(
                ChatMessage(ChatCompletionRole.user, "What is Kotlin")

            )
        )
        val RESPONSE_EXAMPLE = ChatCompletionResult(
            model = "llama2",
            choices = listOf(
                ChatCompletionChoice(
                    message = ChatMessage(
                        role = ChatCompletionRole.assistant,
                        content = "Kotlin is an island"
                    ),
                    index = 11
                )
            ),
        )
    }


}

fun main() {
    val sdk = MlpServiceSDK({ OllamaService(MlpExecutionContext.systemContext) })


    sdk.start()
    sdk.blockUntilShutdown()
}



