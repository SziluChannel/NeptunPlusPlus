import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neptun_app/data/models/event.dart';
import 'package:neptun_app/ui/screens/main_app_frame.dart';
import 'package:neptun_app/ui/viewmodels/timetable_viewmodel.dart';
import 'package:provider/provider.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({
    super.key,
  });

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<TimetableViewModel>(context, listen: false).getEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var timetableViewModel = context.watch<TimetableViewModel>();
    var pageController = PageController(
      initialPage:
          timetableViewModel.dateToEpochDays(timetableViewModel.selectedDate),
    );
    return AppFrame(
      bottomNavigationBar: bottomBar(pageController, timetableViewModel),
      title: Text("Timetable"),
      child: Center(
        child: Column(
          children: [
            timetableArea(pageController, timetableViewModel),
          ],
        ),
      ),
    );
  }

  Flexible timetableArea(
      PageController pageController, TimetableViewModel timetableViewModel) {
    return Flexible(
      child: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) {
          var date = timetableViewModel.epochDaysToDate(index);

          List<Event> currentEvents = timetableViewModel.events.where(
            (e) {
              return e.startDate.year == date.year &&
                  e.startDate.month == date.month &&
                  e.startDate.day == date.day;
            },
          ).toList();

          return RefreshIndicator(
            onRefresh: () async {
              timetableViewModel.getEvents();
            },
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              }),
              child: Builder(builder: (context) {
                if (currentEvents.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return singleEvent(currentEvents[index]);
                    },
                    itemCount: currentEvents.length,
                  );
                } else {
                  return ListView(
                    children: [Container()],
                  );
                }
              }),
            ),
          );
        },
        onPageChanged: (value) => timetableViewModel.updateSelectedDate(value),
      ),
    );
  }

  BottomAppBar bottomBar(
      PageController pageController, TimetableViewModel timetableViewModel) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              pageController.previousPage(
                  duration: Durations.medium1, curve: Curves.bounceInOut);
            },
            icon: Icon(Icons.arrow_left),
          ),
          Text(
            timetableViewModel.getSelectedDate(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          IconButton(
            onPressed: () {
              pageController.nextPage(
                  duration: Durations.medium1, curve: Curves.bounceInOut);
            },
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }

  Column singleEvent(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(event.getStartDate(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0)),
                  ),
                  //Spacer(),
                  Text(event.getEndDate(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  Spacer(
                    flex: 3,
                  ),
                  Text(event.location),
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 10.0,
          //height: 100.0,
          color: Theme.of(context).colorScheme.secondaryContainer,
        )
      ],
    );
  }
}
