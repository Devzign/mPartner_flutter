class CashCoinHistoryUtil {
  String getPhoneNumber(transaction, isFromPerformanceScreen) {
    if (transaction.customerPhone != null && transaction.customerPhone
        .toString()
        .isNotEmpty && transaction.customerPhone != "-") {
      return (!isFromPerformanceScreen)
          ? " (${transaction.customerPhone})"
          : (transaction.saleType == 'Tertiary')
          ? " (${transaction.customerPhone.toString().substring(
          0, 4)}***********${transaction.customerPhone.toString().substring(
          transaction.customerPhone
              .toString()
              .length - 3, transaction.customerPhone
          .toString()
          .length - 1)})"
          : "(${transaction.customerPhone})";
    } else {
      return '';
    }
  }

  String getCustomerName(transaction, isFromPerformanceScreen) {
    if (transaction.customerName != null && transaction.customerName
        .toString()
        .isNotEmpty && transaction.customerName != "-") {
      return (!isFromPerformanceScreen)
          ? "${transaction.customerName}"
          : (transaction.saleType == 'Tertiary' && transaction.customerName
          .toString()
          .length > 5)
          ? "${transaction.customerName.toString().substring(
          0, 2)}***********${transaction.customerName.toString().substring(
          transaction.customerName
              .toString()
              .length - 2, transaction.customerName
          .toString()
          .length)}"
          : "${transaction.customerName}";
    } else {
      return '';
    }
  }
}