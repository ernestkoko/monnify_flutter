import Flutter
import UIKit
import MonnifyiOSSDK

//Created by Ernest Eferetin 11 July 2022 (ernesteferetin@yahoo.com)

private let channelName = "monnify_flutter"
private let INITIALIZE_MONNIFY = "initialise_monnify"
private let MAKE_PAYMENT = "make_monnify_payment"
private let API_KEY = "api_key"
private let CONTRACT_CODE_KEY = "contract_code"
private let APPLICATION_MODE_KEY = "app_mode"
private let TEST_MODE = "test_mode"
private let LIVE_MODE = "live_mode"
private let REQUEST_CODE = 99234
private let RESULT_KEY = "monnify_result"
private let AMOUNT_TO_PAY_KEY = "amount_to_pay"
private let CURRENCY_CODE_KEY = "currency_code"
private let CUSTOMER_NAME_KEY = "customer_name"
private let CUSTOMER_EMAIL_KEY = "customer_email"
private let CUSTOMER_PHONE_NUMBER_KEY = "customer_phone_number"
private let PAYMENT_REFERENCE_KEY = "payment_reference"
private let PAYMENT_DESCRIPTION_KEY = "payment_description"
private let TOKENISE_PAYMENT_KEY = "tokenise_payment"

//PAYMENT KEYS SENT TO CLIENT
private let PAID_STATUS_MESSAGE_KEY = "payment_status"
private let PAID_CUSTOMER_NAME_KEY = "paid_customer_name_key"
private let PAID_CUSTOMER_EMAIL_KEY = "paid_customer_email_key"
private let PAID_TRANSACTION_REFERENCE_KEY = "paid_transaction_response_key"
private let PAID_CURRENCY_CODE_KEY = "paid_currency_code_key"
private let PAID_PAYMENT_DESCRIPTION_KEY = "paid_description_key"
private let PAID_PAYMENT_REFERENCE_KEY = "paid_payment_reference_key"
private let PAID_MESSAGE_KEY = "paid_message_key"
private let PAID_DATE_KEY = "paid_date_key"
private let PAID_AMOUNT_KEY = "paid_amount_key"
private let PAID_PAYMENT_METHOD_KEY = "paid_payment_method_key"
private let PAID_AMOUNT_PAYABLE_KEY = "paid_amount_payable_key"

//PAYMENT METHODS
private let PAYMENT_METHOD_KEY = "payment_method"

///Payment methods values
private let PAYMENT_METHOD_CARD_VALUE = "card"
private let PAYMENT_METHOD_BANK_TRANSFER_VALUE = "bank_transfer"
private let PAYMENT_METHOD_ALL_VALUE = "user_all"


public class SwiftMonnifyFlutterPlugin: NSObject, FlutterPlugin {
    
    var  uiViewController: UIViewController;
    let monnify = Monnify.shared
    init(uiController: UIViewController){
        uiViewController = uiController
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
      let viewController: UIViewController =
                 (UIApplication.shared.delegate?.window??.rootViewController)!;
      
      let instance = SwiftMonnifyFlutterPlugin(uiController: viewController)
      registrar.addMethodCallDelegate(instance, channel: channel)
       registrar.addApplicationDelegate(instance)
    
      
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
      print(call.method)
      switch call.method {
          
      case INITIALIZE_MONNIFY : initialiseMonnify(data:call, result:result)
          
      case MAKE_PAYMENT : makePayment(data:call, flutterResult:result)
          
      default: result(FlutterMethodNotImplemented)
      }
      
    
  }
    
    
    //Initialise Monnify
    private func initialiseMonnify(data: FlutterMethodCall, result: FlutterResult){
        let arg = data.arguments as? Dictionary<String, String>
        
        let apiKey = arg?[API_KEY] ?? ""
        let contractCode = arg?[CONTRACT_CODE_KEY] ?? ""
        let mode = getAppMode(mode:arg?[APPLICATION_MODE_KEY])
        
        
        monnify.setApplicationMode(applicationMode: mode)
        monnify.setApiKey(apiKey: apiKey)
        monnify.setContractCode(contractCode: contractCode)
        
        //send a message to flutter
        result("Monnify initialised")
       
    }
    
    //Make payment
    private func makePayment(data:FlutterMethodCall, flutterResult:@escaping FlutterResult){
        let arg = data.arguments as? Dictionary<String, String>
        
        let amount = arg?[AMOUNT_TO_PAY_KEY] ?? "0"
        let currencyCode = arg?[CURRENCY_CODE_KEY] ?? ""
        let customerName = arg?[CUSTOMER_NAME_KEY] ?? ""
        let customerEmail = arg?[CUSTOMER_EMAIL_KEY] ?? ""
        let customerPhoneNumber = arg?[CUSTOMER_PHONE_NUMBER_KEY] ?? ""
        let paymentRef = arg?[PAYMENT_REFERENCE_KEY] ?? ""
        let paymentDescription = arg?[PAYMENT_DESCRIPTION_KEY] ?? ""
        let paymentMethods = arg?[PAYMENT_METHOD_KEY] ?? ""
        let tokenise = tokeniseCard(card: arg?[TOKENISE_PAYMENT_KEY] ?? "")
        
        let methods = getPaymentMethods(data: paymentMethods)
        
        let amountDec = Decimal(string:amount) ?? 0
        
        
        let parameter = TransactionParameters( amount:amountDec,
                                              currencyCode: currencyCode,
                                              paymentReference: paymentRef,
                                              customerEmail: customerEmail,
                                              customerName: customerName ,
                                              customerMobileNumber: customerPhoneNumber,
                                              paymentDescription: paymentDescription,
                                              incomeSplitConfig: [],
                                              metaData: ["deviceType":"ios", "userId":"user314285714"],
                                              paymentMethods: methods,
                                              tokeniseCard: tokenise)
        
        monnify.initializePayment(withTransactionParameters: parameter,
                                  presentingViewController: uiViewController,
                                  onTransactionSuccessful: { data in
            
            self.transactionResponse(response:data, result:flutterResult )
            
           
        })
        
    }
    
    private func tokeniseCard(card: String)-> Bool{
        if(card == "tokenise"){
            return true
        }else{ return false
            
        }
    }
    
    //Transaction reponse
    private func transactionResponse(response: TransactionResult, result:FlutterResult){
        var status : String
        
        switch response.transactionStatus {
        case TransactionStatus.pending:status = "PENDING"
        case    TransactionStatus.paid:status = "PAID"
        case              TransactionStatus.overpaid : status = "OVERPAID"
        case TransactionStatus.partiallyPaid       : status = "PARTIALLY_PAID"
        case TransactionStatus.failed:      status = "FAILED"
            case TransactionStatus.reversed:status = "REVERSED"
        case TransactionStatus.expired: status = "EXPIRED"
            
        case TransactionStatus.cancelled:  status = "CANCELLED"

        default: status = "ERROR"
        }
        
        var dictonary : [String: String] = [:]
        
        dictonary[PAID_STATUS_MESSAGE_KEY] = status
        dictonary[PAID_CUSTOMER_NAME_KEY] = ""
        dictonary[PAID_TRANSACTION_REFERENCE_KEY] = response.transactionReference
        dictonary[PAID_PAYMENT_REFERENCE_KEY] = response.paymentReference
        dictonary[PAID_AMOUNT_KEY] = _formatDecimalToString(value: response.amountPaid ?? 0)
        dictonary[PAID_AMOUNT_PAYABLE_KEY] = _formatDecimalToString(value: response.amountPayable ?? 0)
        
        //Send the result back to flutter
        result(dictonary)
        
        
    }
    
    //Convert decimal to string
    private func _formatDecimalToString(value : Decimal) -> String{
        
        let string = String(describing: value)
        
        return string
    }
    
    
    ///get the app mode
    private func getAppMode(mode: String?) ->  ApplicationMode {
        print("MODE: \(String(describing: mode))")
        switch mode {
        case LIVE_MODE : return ApplicationMode.live
        case TEST_MODE: return ApplicationMode.test
        default: return ApplicationMode.test
        }
    }
    
    //get payment methods
    private func getPaymentMethods(data: String) -> [PaymentMethod]{
        var array = [PaymentMethod]()
        
        switch data {
            
        case PAYMENT_METHOD_CARD_VALUE :  array.append(PaymentMethod.card)
            
        case PAYMENT_METHOD_BANK_TRANSFER_VALUE: array.append(PaymentMethod.accountTransfer)
            
        default: array.append(PaymentMethod.card)
            array.append(PaymentMethod.accountTransfer)
        }
        
        return array
    }
}
