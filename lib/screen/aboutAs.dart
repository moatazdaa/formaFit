import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('عن تطبيق Formafit'),
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مقدمة عن التطبيق
              _buildSectionTitle('مرحبًا بكم في Formafit'),
              _buildDescription(
                'التطبيق الأمثل لتحقيق أهدافك الصحية واللياقية! تم تصميم Formafit لمساعدتك على تحسين نمط حياتك والحفاظ على لياقتك البدنية من خلال تقديم مجموعة متنوعة من التمارين، خطط التغذية، وتتبع النشاطات اليومية.',
              ),
              SizedBox(height: 20.0),

              // مميزات التطبيق
              _buildSectionTitle('مميزات التطبيق'),
              _buildFeatureItem(
                Icons.fitness_center,
                'برامج تمارين مخصصة',
                'احصل على تمارين مخصصة تناسب مستواك البدني وأهدافك الشخصية. سواء كنت مبتدئًا أو محترفًا، لدينا البرامج المناسبة لك.',
              ),
              _buildFeatureItem(
                Icons.food_bank,
                'خطط التغذية',
                'نوفر لك خطط غذائية متوازنة تتناسب مع احتياجاتك الغذائية وأهدافك الصحية. احصل على نصائح غذائية ووصفات لذيذة لتحافظ على تغذية سليمة.',
              ),
              _buildFeatureItem(
                Icons.directions_walk,
                'تتبع المشي',
                'تابع خطواتك اليومية أو المسافات التي تقطعها بالكيلومترات. احصل على تقارير تفصيلية حول نشاطك اليومي لمساعدتك على تحقيق أهدافك.',
              ),
              _buildFeatureItem(
                Icons.local_drink,
                'تتبع معدل شرب المياه',
                'احرص على شرب كمية كافية من المياه يوميًا من خلال تتبع معدل شربك للمياه. يمكنك تحديد أهداف يومية للبقاء مرطبًا وصحيًا.',
              ),
              _buildFeatureItem(
                Icons.emoji_events,
                'تحديات ونشاطات تفاعلية',
                'انضم إلى تحديات لياقة بدنية تفاعلية وتابع نتائجك وتقدمك. قم بدعوة أصدقائك للمنافسة وتحفيز بعضكم البعض.',
              ),
              _buildFeatureItem(
                Icons.calculate,
                'حاسبة الصحة',
                'استخدم حاسبة الصحة المدمجة لتحديد مؤشر كتلة الجسم، السعرات الحرارية المطلوبة، الوزن المثالي، وحرق السعرات الحرارية. احصل على تقديرات دقيقة لتساعدك على تخطيط نظامك الصحي.',
              ),
              _buildFeatureItem(
                Icons.flag,
                'تحديد الأهداف',
                'حدد أهدافك الشخصية سواء كانت خسارة الوزن، بناء العضلات، أو الحفاظ على اللياقة. تابع تقدمك واحتفل بإنجازاتك.',
              ),
              SizedBox(height: 20.0),

              // تواصل معنا
              _buildSectionTitle('تواصل معنا'),
              _buildContactItem(Icons.email, 'البريد الإلكتروني', 'fitforma753@gmail.com'),
              _buildContactItem(Icons.phone, 'الهاتف', '123-456-789'),
              SizedBox(height: 20.0),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.amber.shade700,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 16.0,
        height: 1.5,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.amber.shade700, size: 40.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.amber.shade700,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String detail) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.amber.shade700, size: 40.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.amber.shade700,
          ),
        ),
        subtitle: Text(
          detail,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
