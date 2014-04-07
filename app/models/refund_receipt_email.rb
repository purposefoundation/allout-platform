class RefundReceiptEmail

  def initialize(transaction)
    @transaction = transaction
  end

  def send!
  	Resque.enqueue(Jobs::SendRefundReceipt, @transaction.id)
  end
end