import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  double? _bmi;
  String _category = '';
  Color _categoryColor = Colors.grey;
  String _advice = '';
  bool _showResult = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  String _heightUnit = 'cm'; // 'cm' or 'ft'
  String _weightUnit = 'kg'; // 'kg' or 'lbs'
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (!_formKey.currentState!.validate()) return;

    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text);

    // Convert to metric
    if (_weightUnit == 'lbs') weight = weight * 0.453592;
    if (_heightUnit == 'ft') {
      height = height * 30.48; // feet to cm
    }

    final heightInM = height / 100;
    final bmi = weight / (heightInM * heightInM);

    String category;
    Color color;
    String advice;

    if (bmi < 18.5) {
      category = 'Underweight';
      color = const Color(0xFF2196F3);
      advice = 'Consider a balanced diet with more calories and nutrients.';
    } else if (bmi < 25.0) {
      category = 'Normal Weight';
      color = const Color(0xFF4CAF50);
      advice = 'Great! Maintain your healthy lifestyle and diet.';
    } else if (bmi < 30.0) {
      category = 'Overweight';
      color = const Color(0xFFFF9800);
      advice = 'Consider regular exercise and a balanced diet.';
    } else if (bmi < 35.0) {
      category = 'Obese (Class I)';
      color = const Color(0xFFF44336);
      advice = 'Consult a doctor for a personalized weight loss plan.';
    } else if (bmi < 40.0) {
      category = 'Obese (Class II)';
      color = const Color(0xFFB71C1C);
      advice = 'Medical supervision is strongly recommended.';
    } else {
      category = 'Obese (Class III)';
      color = const Color(0xFF7B0000);
      advice = 'Please seek immediate medical advice.';
    }

    setState(() {
      _bmi = bmi;
      _category = category;
      _categoryColor = color;
      _advice = advice;
      _showResult = true;
    });

    _animController.forward(from: 0);
  }

  void _reset() {
    setState(() {
      _ageController.clear();
      _weightController.clear();
      _heightController.clear();
      _bmi = null;
      _showResult = false;
    });
    _animController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF00796B),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'BMI Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF004D40), Color(0xFF00BFA5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Reset',
                onPressed: _reset,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Gender selector ───────────────────────────────────
                    _sectionTitle('Gender'),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Male', 'Female'].map((g) {
                        final selected = _gender == g;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _gender = g),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF00796B)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF00796B)
                                      : Colors.grey.shade300,
                                ),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF00796B)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    g == 'Male' ? Icons.male : Icons.female,
                                    color: selected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    g,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // ─── Age ──────────────────────────────────────────────
                    _sectionTitle('Age'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _ageController,
                      label: 'Age',
                      hint: 'Enter your age',
                      icon: Icons.cake_outlined,
                      suffix: 'years',
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter age';
                        final age = int.tryParse(v);
                        if (age == null || age < 2 || age > 120) {
                          return 'Enter valid age (2–120)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // ─── Weight ───────────────────────────────────────────
                    _sectionTitle('Weight'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _weightController,
                            label: 'Weight',
                            hint: _weightUnit == 'kg' ? 'e.g. 70' : 'e.g. 154',
                            icon: Icons.monitor_weight_outlined,
                            suffix: _weightUnit,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Enter weight';
                              final w = double.tryParse(v);
                              if (w == null || w <= 0 || w > 500) {
                                return 'Enter valid weight';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        _unitToggle(
                          options: ['kg', 'lbs'],
                          selected: _weightUnit,
                          onChanged: (v) => setState(() => _weightUnit = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // ─── Height ───────────────────────────────────────────
                    _sectionTitle('Height'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _heightController,
                            label: 'Height',
                            hint: _heightUnit == 'cm' ? 'e.g. 175' : 'e.g. 5.9',
                            icon: Icons.height,
                            suffix: _heightUnit,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Enter height';
                              final h = double.tryParse(v);
                              if (h == null || h <= 0 || h > 300) {
                                return 'Enter valid height';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        _unitToggle(
                          options: ['cm', 'ft'],
                          selected: _heightUnit,
                          onChanged: (v) => setState(() => _heightUnit = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ─── Calculate Button ─────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _calculateBMI,
                        icon: const Icon(Icons.calculate_outlined,
                            color: Colors.white),
                        label: const Text(
                          'Calculate BMI',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00796B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF00796B).withOpacity(0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ─── Result Card ──────────────────────────────────────
                    if (_showResult)
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: _buildResultCard(),
                        ),
                      ),

                    const SizedBox(height: 28),

                    // ─── BMI Table ────────────────────────────────────────
                    _sectionTitle('BMI Classification Table'),
                    const SizedBox(height: 12),
                    _buildBMITable(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF004D40),
          letterSpacing: 0.5,
        ),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String suffix,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF00796B)),
        suffixText: suffix,
        suffixStyle: const TextStyle(
          color: Color(0xFF00796B),
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF00796B), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _unitToggle({
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: options.map((o) {
          final isSelected = o == selected;
          return GestureDetector(
            onTap: () => onChanged(o),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF00796B) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                o,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultCard() {
    final bmiVal = _bmi!;
    // Gauge: 10 → 40 range
    final gaugePercent = ((bmiVal - 10) / 30).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _categoryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: _categoryColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            'Your BMI Result',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bmiVal.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: _categoryColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: _categoryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              _category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _categoryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Gauge bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2196F3),
                        Color(0xFF4CAF50),
                        Color(0xFFFF9800),
                        Color(0xFFF44336),
                        Color(0xFF7B0000),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Positioned(
                  left: (gaugePercent * (MediaQuery.of(context).size.width -
                              32 - 44))
                          .clamp(0,
                              MediaQuery.of(context).size.width - 32 - 44)
                          .toDouble(),
                  child: Container(
                    width: 4,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('10', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text('18.5', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text('25', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text('30', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text('40+', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 18, color: _categoryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _advice,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMITable() {
    final rows = [
      _BMIRow('< 18.5', 'Underweight', const Color(0xFF2196F3), Icons.arrow_downward),
      _BMIRow('18.5 – 24.9', 'Normal Weight', const Color(0xFF4CAF50), Icons.check_circle),
      _BMIRow('25.0 – 29.9', 'Overweight', const Color(0xFFFF9800), Icons.warning_amber),
      _BMIRow('30.0 – 34.9', 'Obese (Class I)', const Color(0xFFF44336), Icons.warning),
      _BMIRow('35.0 – 39.9', 'Obese (Class II)', const Color(0xFFB71C1C), Icons.dangerous),
      _BMIRow('≥ 40.0', 'Obese (Class III)', const Color(0xFF7B0000), Icons.dangerous_outlined),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF004D40),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('BMI Range',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      )),
                ),
                SizedBox(width: 32),
              ],
            ),
          ),
          ...rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            final isHighlighted =
                _bmi != null && _category == row.category;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              color: isHighlighted
                  ? row.color.withOpacity(0.12)
                  : (i.isEven ? Colors.white : const Color(0xFFF8FAFB)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            row.range,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isHighlighted
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isHighlighted
                                  ? row.color
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            row.category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isHighlighted
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isHighlighted
                                  ? row.color
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Icon(
                          row.icon,
                          color: row.color,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  if (i < rows.length - 1)
                    Divider(height: 1, color: Colors.grey.shade100),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BMIRow {
  final String range;
  final String category;
  final Color color;
  final IconData icon;
  const _BMIRow(this.range, this.category, this.color, this.icon);
}
