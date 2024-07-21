
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetPlannerPage extends StatefulWidget {
  @override
  _BudgetPlannerPageState createState() => _BudgetPlannerPageState();
}

class _BudgetPlannerPageState extends State<BudgetPlannerPage> {
  final List<IncomeExpense> _incomeList = [];
  final List<IncomeExpense> _expenseList = [];
  final _formKey = GlobalKey<FormState>();
  String _type = 'Income';
  String _category = '';
  double _amount = 0.0;

  final List<Color> _colorPalette = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.pink,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    double totalIncome = _incomeList.fold(0, (sum, item) => sum + item.amount);
    double totalExpenses = _expenseList.fold(0, (sum, item) => sum + item.amount);
    double balance = totalIncome - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Planner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Total Income: \$${totalIncome.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Balance: \$${balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildForm(),
              SizedBox(height: 20),
              _buildIncomeExpenseList('Income', _incomeList),
              _buildIncomeExpenseList('Expenses', _expenseList),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildExpenseChart()),
                  Expanded(child: _buildBarChart()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _type,
            onChanged: (value) {
              setState(() {
                _type = value!;
              });
            },
            items: ['Income', 'Expenses'].map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              setState(() {
                _category = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              setState(() {
                _amount = double.tryParse(value) ?? 0.0;
              });
            },
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _addIncomeExpense();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addIncomeExpense() {
    final newEntry = IncomeExpense(category: _category, amount: _amount);
    setState(() {
      if (_type == 'Income') {
        _incomeList.add(newEntry);
      } else {
        _expenseList.add(newEntry);
      }
    });
  }

  Widget _buildIncomeExpenseList(String type, List<IncomeExpense> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$type List',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300),  // Set a max height for the list
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return ListTile(
                title: Text('${item.category}: \$${item.amount.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      list.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseChart() {
    if (_expenseList.isEmpty) {
      return Center(child: Text('No expenses added yet.'));
    }

    final data = _expenseList.fold<Map<String, double>>({}, (map, item) {
      map[item.category] = (map[item.category] ?? 0) + item.amount;
      return map;
    });

    final chartData = data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        color: _colorPalette[index % _colorPalette.length],
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();

    return SizedBox(
      height: 200,  // Constrain height of the chart
      child: PieChart(
        PieChartData(
          sections: chartData,
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent touchEvent, PieTouchResponse? touchResponse) {
              // Handle touch interactions
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    if (_expenseList.isEmpty) {
      return Center(child: Text('No expenses added yet.'));
    }

    final data = _expenseList.fold<Map<String, double>>({}, (map, item) {
      map[item.category] = (map[item.category] ?? 0) + item.amount;
      return map;
    });

    final barData = data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: _colorPalette[index % _colorPalette.length],
            width: 16,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barData,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(data.keys.toList()[value.toInt()]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IncomeExpense {
  final String category;
  final double amount;

  IncomeExpense({required this.category, required this.amount});
}

void main() => runApp(MaterialApp(
  home: BudgetPlannerPage(),
));
