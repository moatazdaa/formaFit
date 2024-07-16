import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:formafit/provider/waterProvider.dart';

class WaterTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);
    final progress = waterProvider.dailyProgress / waterProvider.dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: Text('تتبع معدل المياه'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context, waterProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // مؤشر دائري لعرض نسبة التقدم في استهلاك المياه اليومية
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 15.0,
              percent: progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_drink,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              progressColor: Colors.blue,
            ),
          ),
          // يمكن استخدام أيقونة إضافية للإشارة إلى تتبع المياه بدلاً من الصورة
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.opacity, // أيقونة قطرات المياه
              size: 100.0,
              color: Colors.blue[200],
            ),
          ),
          // نص لعرض كمية المياه اليومية المستهلكة والهدف اليومي
          Text(
            'كمية المياه اليومية: ${waterProvider.dailyProgress} من ${waterProvider.dailyGoal} مل',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          // زر لإضافة مياه جديدة
          ElevatedButton(
            onPressed: () {
              _showAddWaterDialog(context, waterProvider);
            },
            child: Text('إضافة مياه'),
          ),
          // قائمة لعرض تاريخ استهلاك المياه اليومي
          Expanded(
            child: WaterHistoryList(),
          ),
        ],
      ),
    );
  }

  // حوار لإضافة كمية مياه جديدة
  void _showAddWaterDialog(BuildContext context, WaterProvider waterProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('إضافة مياه'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  _addWaterWithMessage(context, waterProvider, 250); // كمية كوب ماء
                  Navigator.of(context).pop();
                },
                child: Text('كوب ماء (250 مل)'),
              ),
              TextButton(
                onPressed: () {
                  _addWaterWithMessage(context, waterProvider, 500); // كمية زجاجة ماء صغيرة
                  Navigator.of(context).pop();
                },
                child: Text('زجاجة ماء صغيرة (500 مل)'),
              ),
              TextButton(
                onPressed: () {
                  _addWaterWithMessage(context, waterProvider, 1000); // كمية لتر ماء
                  Navigator.of(context).pop();
                },
                child: Text('لتر ماء (1000 مل)'),
              ),
            ],
          ),
        );
      },
    );
  }

  // رسالة تحفيزية بعد إضافة كمية مياه جديدة
  void _showMotivationalMessage(BuildContext context, int amount) {
    final messages = [
      'رائع! استمر في الشرب لتحافظ على صحتك!',
      'عمل رائع! فقط القليل لتصل إلى هدفك اليومي!',
      'أحسنت! استمر في هذا الأداء الجيد!',
    ];
    final randomMessage = (messages..shuffle()).first;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(randomMessage),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // إضافة كمية مياه جديدة مع عرض رسالة تحفيزية
  void _addWaterWithMessage(BuildContext context, WaterProvider waterProvider, int amount) {
    waterProvider.addWater(amount);
    _showMotivationalMessage(context, amount);
  }

  // حوار لتغيير هدف المياه اليومي
  void _showSettingsDialog(BuildContext context, WaterProvider waterProvider) {
    TextEditingController controller = TextEditingController(
      text: waterProvider.dailyGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تغيير هدف المياه اليومي'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'أدخل هدف المياه اليومي (بالمل)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int newGoal = int.parse(controller.text);
                waterProvider.updateDailyGoal(newGoal);
                Navigator.of(context).pop();
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}

class WaterHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);

    return ListView.builder(
      itemCount: waterProvider.intakes.length,
      itemBuilder: (context, index) {
        final intake = waterProvider.intakes[index];
        return ListTile(
          title: Text('${intake.date.day}/${intake.date.month}/${intake.date.year}'),
          subtitle: Text('استهلاك المياه: ${intake.amount} مل'),
        );
      },
    );
  }
}
