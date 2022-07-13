package com.example.monnify_flutter


import android.app.Activity.RESULT_OK
import android.content.Intent
import com.teamapt.monnify.sdk.Monnify
import com.teamapt.monnify.sdk.MonnifyTransactionResponse
import com.teamapt.monnify.sdk.Status
import com.teamapt.monnify.sdk.data.model.TransactionDetails
import com.teamapt.monnify.sdk.data.model.TransactionType
import com.teamapt.monnify.sdk.model.PaymentMethod
import com.teamapt.monnify.sdk.service.ApplicationMode
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.math.BigDecimal


private const val channelName = "monnify_flutter"
private const val INITIALIZE_MONNIFY = "initialise_monnify"
private const val MAKE_PAYMENT = "make_monnify_payment"
private const val API_KEY = "api_key"
private const val CONTRACT_CODE_KEY = "contract_code"
private const val APPLICATION_MODE_KEY = "app_mode"
private const val TEST_MODE = "test_mode"
private const val LIVE_MODE = "live_mode"
private const val REQUEST_CODE = 99234
private const val RESULT_KEY = "monnify_result"
private const val AMOUNT_TO_PAY_KEY = "amount_to_pay"
private const val CURRENCY_CODE_KEY = "currency_code"
private const val CUSTOMER_NAME_KEY = "customer_name"
private const val CUSTOMER_EMAIL_KEY = "customer_email"
private const val PAYMENT_REFERENCE_KEY = "payment_reference"
private const val PAYMENT_DESCRIPTION_KEY = "payment_description"

//PAYMENT KEYS SENT TO CLIENT
private const val PAID_STATUS_MESSAGE_KEY = "payment_status"
private const val PAID_CUSTOMER_NAME_KEY = "paid_customer_name_key"
private const val PAID_CUSTOMER_EMAIL_KEY = "paid_customer_email_key"
private const val PAID_TRANSACTION_REFERENCE_KEY = "paid_transaction_response_key"
private const val PAID_CURRENCY_CODE_KEY = "paid_currency_code_key"
private const val PAID_PAYMENT_DESCRIPTION_KEY = "paid_description_key"
private const val PAID_PAYMENT_REFERENCE_KEY = "paid_payment_reference_key"
private const val PAID_MESSAGE_KEY = "paid_message_key"
private const val PAID_DATE_KEY = "paid_date_key"
private const val PAID_AMOUNT_KEY = "paid_amount_key"
private const val PAID_PAYMENT_METHOD_KEY = "paid_payment_method_key"
private const val PAID_AMOUNT_PAYABLE_KEY = "paid_amount_payable_key"

//PAYMENT METHODS
private const val PAYMENT_METHOD_KEY = "payment_method"

///Payment methods values
private const val PAYMENT_METHOD_CARD_VALUE = "card"
private const val PAYMENT_METHOD_BANK_TRANSFER_VALUE = "bank_transfer"
private const val PAYMENT_METHOD_ALL_VALUE = "user_all"


class MethodCallHandlerImpl(
    messenger: BinaryMessenger?,
    private val binding: ActivityPluginBinding
) :
    MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {

    private var channel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private val monnify = Monnify.instance


    init {
        channel = MethodChannel(messenger!!, channelName)

        channel?.setMethodCallHandler(this)

        binding.addActivityResultListener(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        this.result = result

        when (call.method) {

            INITIALIZE_MONNIFY -> {
                initialiseMonnify(call.arguments)
            }

            MAKE_PAYMENT -> {
                makePayment(call.arguments)
            }

            else -> result.notImplemented()
        }

    }

    /**
     * @initializeMonnify initializes monnify
     * @param arg is a map sent from the client side
     */
    private fun initialiseMonnify(arg: Any) {
        try {
            val result: HashMap<String, String> = arg as HashMap<String, String>

            val apiKey = result[API_KEY]!!
            val contractCode = result[CONTRACT_CODE_KEY]!!
            val appMode = result[APPLICATION_MODE_KEY]!!

            val mode = getAppMode(appMode)

            monnify.setApiKey(apiKey)

            monnify.setContractCode(contractCode)

            monnify.setApplicationMode(mode)


        } catch (error: Exception) {

            result?.error("23", "Monnify not initialised", error.message)

        }

        result?.success("Monnify initialised")

    }

    /**
     * It is invoked when making transaction
     * @param arg is the data that was passed in from the flutter side to make payment
     */
    private fun makePayment(arg: Any) {

        val inputCall = arg as HashMap<String, String>
        val amount = inputCall[AMOUNT_TO_PAY_KEY]
        val currencyCode = inputCall[CURRENCY_CODE_KEY]!!
        val customerName = inputCall[CUSTOMER_NAME_KEY]!!
        val customerEmail = inputCall[CUSTOMER_EMAIL_KEY]
        val paymentRef = inputCall[PAYMENT_REFERENCE_KEY]
        val paymentDesc = inputCall[PAYMENT_DESCRIPTION_KEY]
        val paymentMethods = inputCall[PAYMENT_METHOD_KEY]
        val methods = getPaymentMethod(paymentMethods!!)

        val transaction = TransactionDetails.Builder()
            .amount(BigDecimal(amount))
            .currencyCode(currencyCode)
            .customerName(customerName)
            .customerEmail(customerEmail!!)
            .paymentReference(paymentRef!!)
            .paymentMethods(methods)
            .paymentDescription(paymentDesc!!)
            .metaData(
                hashMapOf(
                    Pair("deviceType", "mobile_android"),
                    Pair("ip", "127.168.22.98")
                    // any other info
                )
            ).build()

        // Initialise the payment
        monnify.initializePayment(
            binding.activity,
            transaction,
            REQUEST_CODE,
            RESULT_KEY
        )
    }


    /**
     * returns an [ArrayList] of [PaymentMethod]
     * @param value is the value of the payment method that was sent from the flutter side
     */
    private fun getPaymentMethod(value: String): ArrayList<PaymentMethod> {
        val methods: ArrayList<PaymentMethod> = arrayListOf()

        return when (value) {

            PAYMENT_METHOD_CARD_VALUE -> {
                methods.add(PaymentMethod.CARD)
                methods
            }

            PAYMENT_METHOD_BANK_TRANSFER_VALUE -> {
                methods.add(PaymentMethod.ACCOUNT_TRANSFER)
                methods
            }

            PAYMENT_METHOD_ALL_VALUE -> {
                methods.add(PaymentMethod.CARD)
                methods.add(PaymentMethod.ACCOUNT_TRANSFER)
                methods
            }

            else -> {
                methods.add(PaymentMethod.CARD)
                methods.add(PaymentMethod.ACCOUNT_TRANSFER)
                methods
            }

        }

    }

    /**
     * A method that accepts string as param and returns [ApplicationMode] mode (TEST or LIVE)
     * @param mode is the string passed from client to this server
     */
    private fun getAppMode(mode: String): ApplicationMode {

        return if (mode == LIVE_MODE)
            ApplicationMode.LIVE

        else ApplicationMode.TEST
    }

    /**
     * this is the call back that is invoked when the activity result returns a value after calling
     * startActivityForResult().
     * @param data is the intent that has the bundle where we can get our result [MonnifyTransactionResponse]
     * @param requestCode if it matches with our [REQUEST_CODE] it means the result if the one we
     * asked for.
     * @param resultCode, it is okay if it equals [RESULT_OK]
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {

        //Check if the requestCode and the resultCode are okay
        if (requestCode == REQUEST_CODE && resultCode == RESULT_OK) {

            val monnifyTransactionResponse =
                data!!.getParcelableExtra<MonnifyTransactionResponse>(RESULT_KEY)
                        as MonnifyTransactionResponse


            val message = when (monnifyTransactionResponse.status) {
                ///if you change any string here, you will have to go change the same on the flutter
                // side because they are being used to track what to send to the user for display
                Status.PENDING -> "Transaction not paid."
                Status.PAID -> "Customer paid exact amount."
                Status.OVERPAID -> "Customer paid more than expected amount."
                Status.PARTIALLY_PAID -> "Customer paid less than expected amount."
                Status.FAILED -> "Transaction completed unsuccessfully. This means no payment came in for Account Transfer method or attempt to charge card failed."
                Status.PAYMENT_GATEWAY_ERROR -> "Payment gateway error."

                else -> ""
            }
            val paymentMethod = when (monnifyTransactionResponse.paymentMethod) {
                TransactionType.CARD -> "CARD"
                TransactionType.BANK_TRANSFER -> "BANK TRANSFER"
                else -> ""
            }

            val paymentResponse = HashMap<String, Any>()
            paymentResponse[PAID_STATUS_MESSAGE_KEY] = message
            paymentResponse[PAID_CUSTOMER_NAME_KEY] = monnifyTransactionResponse.customerName
            paymentResponse[PAID_CUSTOMER_EMAIL_KEY] = monnifyTransactionResponse.customerEmail
            paymentResponse[PAID_TRANSACTION_REFERENCE_KEY] =
                monnifyTransactionResponse.transactionReference
            paymentResponse[PAID_CURRENCY_CODE_KEY] = monnifyTransactionResponse.currencyCode
            paymentResponse[PAID_PAYMENT_DESCRIPTION_KEY] =
                monnifyTransactionResponse.paymentDescription
            paymentResponse[PAID_PAYMENT_REFERENCE_KEY] =
                monnifyTransactionResponse.paymentReference
            paymentResponse[PAID_MESSAGE_KEY] = monnifyTransactionResponse.message ?: ""
            paymentResponse[PAID_DATE_KEY] = monnifyTransactionResponse.paidOn ?: ""
            paymentResponse[PAID_AMOUNT_KEY] = monnifyTransactionResponse.amountPaid.toString()
            paymentResponse[PAID_PAYMENT_METHOD_KEY] = paymentMethod
            paymentResponse[PAID_AMOUNT_PAYABLE_KEY] =
                monnifyTransactionResponse.amountPayable.toString()

            //send a result
            result?.success(paymentResponse)


        } else {

            result?.error("22", "Payment was not successful", "Monnify has error")

        }
        //return true to tell the platform result has been handled
        return true
    }


    /**
     * dispose the channel when this handler detaches from the activity
     */
    fun dispose() {
        channel?.setMethodCallHandler(null)
        channel = null
    }
}




