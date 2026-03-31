class CpuBenchmark {
  final String cpu;
  final int single;
  final int multi;

  CpuBenchmark({
    required this.cpu,
    required this.single,
    required this.multi,
  });
}

final List<CpuBenchmark> cpuDataset = [
CpuBenchmark(cpu: "Apple A19 Pro", single: 5180, multi: 14843),
CpuBenchmark(cpu: "Apple A19", single: 5065, multi: 14469),
CpuBenchmark(cpu: "Apple A18 Pro", single: 4000, multi: 12864),
CpuBenchmark(cpu: "Apple A18", single: 3937, multi: 12400),
CpuBenchmark(cpu: "Apple A17 Pro", single: 4522, multi: 12198),
CpuBenchmark(cpu: "Apple A16 Bionic", single: 3986, multi: 10903),
CpuBenchmark(cpu: "Apple A15 Bionic", single: 3600, multi: 9883),
CpuBenchmark(cpu: "Apple A14 Bionic", single: 3350, multi: 8548),
CpuBenchmark(cpu: "Apple M3 8 CORE", single: 4715, multi: 19095),
CpuBenchmark(cpu: "Apple A12X Bionic", single: 2648, multi: 11039),
CpuBenchmark(cpu: "Apple A12 Bionic", single: 3577, multi: 9800),
CpuBenchmark(cpu: "Apple A11 Bionic", single: 2300, multi: 5200),
CpuBenchmark(cpu: "Apple M5 10 Core", single: 5803, multi: 27718),
CpuBenchmark(cpu: "Apple M4 9 Core", single: 4476, multi: 2219),
CpuBenchmark(cpu: "Snapdragon 8cx Gen 3 @ 3.0 GHz", single: 2418, multi: 11832),
CpuBenchmark(cpu: "Snapdragon 8 Gen2 Mobile Platform for Galaxy", single: 3093, multi: 9362),
CpuBenchmark(cpu: "Snapdragon 860 @ 2.96 GHz", single: 1428, multi: 4878),
CpuBenchmark(cpu: "Snapdragon 8350", single: 2477, multi: 5070),
CpuBenchmark(cpu: "Snapdragon X Plus (8-core) @ 3.30 GHz", single: 2936, multi: 15456),
CpuBenchmark(cpu: "SM8750", single: 3100, multi: 10169),
CpuBenchmark(cpu: "QTI SM8850", single: 2540, multi: 13040),
CpuBenchmark(cpu: "QTI SM8735", single: 2554, multi: 11385),
CpuBenchmark(cpu: "QTI QCS8550", single: 3332, multi: 10487),
CpuBenchmark(cpu: "QTI SG8275", single: 3208, multi: 10036),
CpuBenchmark(cpu: "QTI SM8750P", single: 2995, multi: 13558),
CpuBenchmark(cpu: "QTI SM8550", single: 2874, multi: 9010),
CpuBenchmark(cpu: "Mediatek Dimensity 9400 (MT6991)", single: 2927, multi: 11803),
CpuBenchmark(cpu: "Mediatek Dimensity 9200 (MT6985)", single: 2844, multi: 8046),
CpuBenchmark(cpu: "Mediatek Dimensity 8400-Turbo (MT6899)", single: 2639, multi: 8451),
CpuBenchmark(cpu: "Mediatek Dimensity 8350 (MT6897)", single: 2509, multi: 7408),
CpuBenchmark(cpu: "Mediatek Dimensity 8200-Ultimate (MT6896)", single: 2473, multi: 7463),
CpuBenchmark(cpu: "Mediatek Dimensity 7300-Ultra (MT6878)", single: 2244, multi: 6332),
CpuBenchmark(cpu: "Mediatek Dimensity 7200-Pro (MT6886)", single: 2051, multi: 4756),
CpuBenchmark(cpu: "Mediatek Dimensity 7025 (MT6855)", single: 2833, multi: 4579),
CpuBenchmark(cpu: "MediaTek Dimensity 900 (MT6877)", single: 1823, multi: 4874),
CpuBenchmark(cpu: "Mediatek MT6989", single: 2602, multi: 10944),
CpuBenchmark(cpu: "Mediatek MT6983W-CZA", single: 3288, multi: 9136),
CpuBenchmark(cpu: "MediaTek MT6895", single: 2453, multi: 7534),
CpuBenchmark(cpu: "Mediatek MT6893", single: 2460, multi: 6326),
CpuBenchmark(cpu: "MediaTek MT6879", single: 1933, multi: 5421),
CpuBenchmark(cpu: "Mediatek Kompanio Ultra 910", single: 3867, multi: 14532),
CpuBenchmark(cpu: "Google Tensor G5", single: 3513, multi: 11942),
CpuBenchmark(cpu: "Google Tensor G4", single: 3024, multi: 8221),
CpuBenchmark(cpu: "Google Tensor G3", single: 2393, multi: 8036),
CpuBenchmark(cpu: "Google Tensor", single: 2030, multi: 6701),
CpuBenchmark(cpu: "Samsung Exynos 2100", single: 2016, multi: 5553),
CpuBenchmark(cpu: "Samsung Exynos 990", single: 1756, multi: 6025),
CpuBenchmark(cpu: "Samsung Exynos 980", single: 1700, multi: 4584),
CpuBenchmark(cpu: "Samsung s5e9945", single: 2920, multi: 11029),
CpuBenchmark(cpu: "vendor Kirin9000", single: 2592, multi: 6914),
CpuBenchmark(cpu: "vendor Kirin9000E", single: 2404, multi: 7141),
CpuBenchmark(cpu: "vendor Kirin990", single: 2230, multi: 6131),
CpuBenchmark(cpu: "Unisoc T820", single: 1592, multi: 5577),
CpuBenchmark(cpu: "Spreadtrum UMS9620", single: 1840, multi: 5720),
];

List<CpuBenchmark> buildSingleComparison(
    int userScore, String deviceName) {
  List<CpuBenchmark> list = [...cpuDataset];
  list.add(
    CpuBenchmark(
      cpu: deviceName,
      single: userScore,
      multi: 0,
    ),
  );
  list.sort((a, b) => b.single.compareTo(a.single));
  return list;
}

List<CpuBenchmark> buildMultiComparison(
    int userScore, String deviceName) {
  List<CpuBenchmark> list = [...cpuDataset];
  list.add(
    CpuBenchmark(
      cpu: deviceName,
      single: 0,
      multi: userScore,
    ),
  );
  list.sort((a, b) => b.multi.compareTo(a.multi));
  return list;
}