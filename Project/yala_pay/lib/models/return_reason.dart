enum ReturnReason {
  noFunds,
  postDatedCheque,
  signatureDiffers,
  alterationInDate,
  requiresEndorsement,
  notDrawnOnUs,
  drawerDeceased,
  accountClosed,
  stoppedByDrawer,
  dateOrBeneficiaryMissing,
  presentmentCycleExpired,
  alreadyPaid,
  requiresSignature,
  dataMismatch,
}

extension ReturnReasonExtension on ReturnReason {
  static const Map<ReturnReason, String> _values = {
    ReturnReason.noFunds: "No funds/insufficient funds",
    ReturnReason.postDatedCheque:
        "Cheque post-dated, please represent on due date",
    ReturnReason.signatureDiffers: "Drawer's signature differs",
    ReturnReason.alterationInDate:
        "Alteration in date/words/figures requires drawer's full signature",
    ReturnReason.requiresEndorsement:
        "Order cheque requires payee's endorsement",
    ReturnReason.notDrawnOnUs: "Not drawn on us",
    ReturnReason.drawerDeceased: "Drawer deceased/bankrupt",
    ReturnReason.accountClosed: "Account closed",
    ReturnReason.stoppedByDrawer:
        "Stopped by drawer due to cheque lost, bearer's bankruptcy or a judicial order",
    ReturnReason.dateOrBeneficiaryMissing: "Date/beneficiary name is required",
    ReturnReason.presentmentCycleExpired: "Presentment cycle expired",
    ReturnReason.alreadyPaid: "Already paid",
    ReturnReason.requiresSignature: "Requires drawer's signature",
    ReturnReason.dataMismatch:
        "Cheque information and electronic data mismatch",
  };

  String get description => _values[this]!;

  static ReturnReason? fromDescription(String description) {
    final entry = _values.entries.firstWhere(
      (entry) => entry.value == description,
      orElse: () => const MapEntry(ReturnReason.noFunds,
          ""), // Provide a default entry with an empty description
    );
    return entry.value.isEmpty ? null : entry.key; // Check for an empty match
  }
}
