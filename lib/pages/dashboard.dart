part of 'pages.dart';

class Dashboard extends StatefulWidget {
  // const Dashboard({ Key? key }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late People _myPeople;

  void getMyPeople() async{
    People people = await Prefs.getPeople();
    setState(() {
      _myPeople = people;
    });
    print(_myPeople.email);
  }

  @override
  void initState() {
    getMyPeople();
    super.initState();
  }

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/servisor.png'),
                    image: NetworkImage(_myPeople.img),
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _myPeople.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        _myPeople.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white54
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}