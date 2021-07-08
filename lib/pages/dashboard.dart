part of 'pages.dart';

class Dashboard extends StatefulWidget {
  // const Dashboard({ Key? key }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late People _myPeople;
  // void getMyPeople() async{
  //   People? people = await Prefs.getPeople();
  //   setState(() {
  //     _myPeople = people;
  //   });
  //   print(_myPeople.email);
  // }

  // @override
  // void initState() {
  //   getMyPeople();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Servisor Chat"),
      ),
      drawer: menuDrawer(),
      body: Center(
        child: Text("Dashboard"),
      ),
    );
  }

  Widget menuDrawer(){
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue
            ),
            child: Row(
              children: [
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}