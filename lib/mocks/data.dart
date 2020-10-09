
import 'package:gatabank/models/bank.dart';

class BankMockData {
  static list(){
    return {
      "data" : [
        {
          Bank.ID: "0",
          Bank.NAME: "ocb",
          Bank.IMAGE: "assets/ocb.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 29,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 3000000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "4 năm",
          Bank.VERIFIED_IN: "2-3 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
            "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND hoặc hộ chiếu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "1",
          Bank.NAME: "shinhan",
          Bank.IMAGE: "assets/shinhan.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 18,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 3500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "4 năm",
          Bank.VERIFIED_IN: "trong ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "2",
          Bank.NAME: "Fecredit",
          Bank.IMAGE: "assets/fecredit.png",
          Bank.MIN_LOAN_AMOUNT: 5000000,
          Bank.MAX_LOAN_AMOUNT: 50000000,
          Bank.INTEREST_PERCENTAGE: 35,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Dư nợ giảm dần -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 3000000,
          Bank.MIN_LOAN_TERM: "6 thang",
          Bank.MAX_LOAN_TERM: "3 năm",
          Bank.VERIFIED_IN: "15 Phút",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Không cần giấy tờ chứng minh nơi cư trú",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "3",
          Bank.NAME: "vib",
          Bank.IMAGE: "assets/vib.png",
          Bank.MIN_LOAN_AMOUNT: 20000000,
          Bank.MAX_LOAN_AMOUNT: 50000000,
          Bank.INTEREST_PERCENTAGE: 17,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 5000000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "trong ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ chiếu\n Xác nhận tình trạng hôn nhân",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Giấy phép kinh doanh\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "4",
          Bank.NAME: "vpbank",
          Bank.IMAGE: "assets/vpbank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 16,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 4500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "1-2 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ chiếu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "5",
          Bank.NAME: "acbbank",
          Bank.IMAGE: "assets/acbbank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 19,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 4500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "3-4 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ chiếu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "6",
          Bank.NAME: "vietcombank",
          Bank.IMAGE: "assets/vietcombank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 13,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 4500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "5-6 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ chiếu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "7",
          Bank.NAME: "techcombank",
          Bank.IMAGE: "assets/techcombank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 18,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 4500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "6 năm",
          Bank.VERIFIED_IN: "5 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ khẩu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "8",
          Bank.NAME: "agribank",
          Bank.IMAGE: "assets/agribank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 50000000,
          Bank.INTEREST_PERCENTAGE: 14,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 3500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "3-4 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ khẩu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "9",
          Bank.NAME: "vietbank",
          Bank.IMAGE: "assets/vietbank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 150000000,
          Bank.INTEREST_PERCENTAGE: 19,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 5500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "2-3 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ khẩu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "10",
          Bank.NAME: "sacombank",
          Bank.IMAGE: "assets/sacombank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 60000000,
          Bank.INTEREST_PERCENTAGE: 13,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 3500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "2-3 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "11",
          Bank.NAME: "scb",
          Bank.IMAGE: "assets/scb.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 15,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 5500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "6 năm",
          Bank.VERIFIED_IN: "3-4 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ chiếu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "12",
          Bank.NAME: "homecredit",
          Bank.IMAGE: "assets/homecredit.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 60000000,
          Bank.INTEREST_PERCENTAGE: 36,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 4500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "1-2 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND/Hộ khẩu",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "13",
          Bank.NAME: "tpbank",
          Bank.IMAGE: "assets/tpbank.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 100000000,
          Bank.INTEREST_PERCENTAGE: 15,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 4500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "7 năm",
          Bank.VERIFIED_IN: "3-4 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
        {
          Bank.ID: "14",
          Bank.NAME: "hsbc",
          Bank.IMAGE: "assets/hsbc.png",
          Bank.MIN_LOAN_AMOUNT: 10000000,
          Bank.MAX_LOAN_AMOUNT: 150000000,
          Bank.INTEREST_PERCENTAGE: 18,
          Bank.INTEREST_TYPE: "Cố định",
          Bank.INTEREST_CAL_METHOD: "Lãi suất cố định -\n Số tiền phải trả\n cố định",
          Bank.MIN_INCOME: 4500000,
          Bank.MIN_LOAN_TERM: "1 năm",
          Bank.MAX_LOAN_TERM: "5 năm",
          Bank.VERIFIED_IN: "3-4 ngày",
          Bank.BANK_FEE: {
            BankFee.PENALTY_INTEREST: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.PENALTY_FEE: "Chậm trả lãi: 10%/năm\nChậm trả nợ gốc: 150% lãi suất đã duyệt",
            BankFee.EARLIER_PAYMENT_FEE: "Tất toán từ sau 3 kỳ thanh toán kể từ ngày giả ngân: 5% giá trị trả trước hạn\n"
                "Tất toán từ sau 6 kỳ thanh toán kể từ ngày giả ngân: 3% giá trị trả trước hạn"
          },
          Bank.DISCOUNTS:[],
          Bank.REQUIREMENT: {
            BankRequirement.AGE : "Từ 21",
            BankRequirement.PERSONAL_IDENTIFIER: "CMND",
            BankRequirement.INCOME_IDENTIFIER: "Một trong các giấy tờ sau:\n Hợp đồng lao động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n",
            BankRequirement.HOME_IDENTIFIER: "Hộ khẩu/KT3",
            BankRequirement.OTHER: "-"
          }
        },
      ]
    };
  }
}

class UserMockData{
  static login(){
    return {
      "data": {
        "id": "1",
        "full_name": "Lvhoa",
        "phone": "+84937134373"
      }
    };
  }
}