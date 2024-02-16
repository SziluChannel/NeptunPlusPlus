import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neptun_app/ui/screens/main_app_frame.dart';
import 'package:neptun_app/ui/viewmodels/personal_viewmodel.dart';
import 'package:provider/provider.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({
    super.key,
  });

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<PersonalViewmodel>(context, listen: false).getPersonalData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PersonalViewmodel personalViewmodel = context.watch<PersonalViewmodel>();

    return AppFrame(
      title: Text("Personal"),
      child: RefreshIndicator(
        onRefresh: () async {
          personalViewmodel.getPersonalData();
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          }),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              singleItem("Name:", personalViewmodel.data?.fullName),
              singleItem("EduId:", personalViewmodel.data?.eduId),
              singleItem("Neptun code:", personalViewmodel.data?.neptunCode),
              singleItem("Birth date:", personalViewmodel.data?.getBirthDate()),
              singleItem(
                  "Birth country:", personalViewmodel.data?.birthCountry),
              singleItem("Birth county:", personalViewmodel.data?.birthCounty),
              singleItem("Birth place:", personalViewmodel.data?.birthPlace),
              singleItem("Gender:", personalViewmodel.data?.gender),
              singleItem("Mothers name:", personalViewmodel.data?.mothersName),
              singleItem(
                  "TAJ number:", personalViewmodel.data?.tajNumber.toString()),
              singleItem(
                  "TAX number:", personalViewmodel.data?.taxNumber.toString()),
              singleItem(
                  "OM number:", personalViewmodel.data?.omNumber.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Column singleItem(String property, String? value) {
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(property),
              SelectableText(value ?? ""),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
