part of 'pages.dart';

class Dashboard extends StatefulWidget {
  // const Dashboard({ Key? key }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  People _myPeople = new People(email: '', name: '', img: '', token: '', uid: '');

  Future<void> getMyPeople() async{
    print('GET PEOPLE MASUK');
    People people = await Prefs.getPeople();
    
    setState(() {
      _myPeople = people;
    });
    print(_myPeople.email);

    print('----------------');
    print('CURRENT USER FROM FIREBASE: ');
    print(_myPeople.email);
    print(_myPeople.name);
    print('----------------');
  }

  @override
  void initState() {
    _myPeople = new People(email: '', name: '', img: '', token: '', uid: '');
    getMyPeople();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getMyPeople();
    print('----------------');
    print('CURRENT USER: ');
    print(_myPeople.email);
    print(_myPeople.name);
    print('----------------');
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
                    // image: NetworkImage(_myPeople.img),
                    image: AssetImage('assets/images/servisor.png'),
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
                        // 'rei',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        _myPeople.email,
                        // 'rei@gmail.com',
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
          ListTile(
            onTap: (){

            },
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            trailing: Icon(Icons.navigate_next),
          ),

          ListTile(
            onTap: (){

            },
            leading: Icon(Icons.lock),
            title: Text('Reset Password'),
            trailing: Icon(Icons.navigate_next),
          ),

          ListTile(
            onTap: (){

            },
            leading: Icon(Icons.image),
            title: Text('Edit Photo'),
            trailing: Icon(Icons.navigate_next),
          ),

          ListTile(
            onTap: (){

            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            trailing: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}