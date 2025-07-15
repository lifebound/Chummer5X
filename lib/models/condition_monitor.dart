class ConditionMonitor {
  final int physicalCM;          // Maximum physical condition monitor
  final int physicalCMFilled;    // Current physical damage taken
  final int physicalCMOverflow;  // Physical overflow (death track)
  final int physicalCMThresholdOffset; // Physical threshold offset
  
  final int stunCM;              // Maximum stun condition monitor  
  final int stunCMFilled;        // Current stun damage taken
  final int stunCMThresholdOffset; // Stun threshold offset

  const ConditionMonitor({
    this.physicalCM = 0,
    this.physicalCMFilled = 0,
    this.physicalCMOverflow = 0,
    this.physicalCMThresholdOffset = 0,
    this.stunCM = 0,
    this.stunCMFilled = 0,
    this.stunCMThresholdOffset = 0,
  });

  // Computed properties
  int get physicalCMTotal => physicalCM + physicalCMThresholdOffset;
  int get stunCMTotal => stunCM + stunCMThresholdOffset;
  
  bool get isPhysicalDown => physicalCMFilled >= physicalCMTotal;
  bool get isPhysicalDead => physicalCMFilled >= (physicalCMTotal + physicalCMOverflow);
  bool get isStunDown => stunCMFilled >= stunCMTotal;
  
  // Status strings
  String get physicalStatus {
    if (isPhysicalDead) return 'Dead';
    if (isPhysicalDown) return 'Down';
    return 'Up';
  }
  
  String get stunStatus {
    if (isStunDown) return 'Unconscious';
    return 'Conscious';
  }

  factory ConditionMonitor.fromXml(Map<String, dynamic> xmlData, Map<String, dynamic> calculatedValues) {
    return ConditionMonitor(
      // From calculatedvalues
      physicalCM: int.tryParse(calculatedValues['physicalcm']?.toString() ?? '0') ?? 0,
      physicalCMOverflow: int.tryParse(calculatedValues['physicalcmoverflow']?.toString() ?? '0') ?? 0,
      physicalCMThresholdOffset: int.tryParse(calculatedValues['physicalcmthresholdoffset']?.toString() ?? '0') ?? 0,
      stunCM: int.tryParse(calculatedValues['stuncm']?.toString() ?? '0') ?? 0,
      stunCMThresholdOffset: int.tryParse(calculatedValues['stuncmthresholdoffset']?.toString() ?? '0') ?? 0,
      
      // From root level
      physicalCMFilled: int.tryParse(xmlData['physicalcmfilled']?.toString() ?? '0') ?? 0,
      stunCMFilled: int.tryParse(xmlData['stuncmfilled']?.toString() ?? '0') ?? 0,
    );
  }
}