module Jobs
  class SendRefundReceipt
    @queue = :send_user_email

    def self.perform(transaction_id)
      Emailer.refund_receipt_email(Transation.find(transaction_id)).deliver
    end
  end
end