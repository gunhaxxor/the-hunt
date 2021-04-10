

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learning_flutter/services/locationService.dart';
import 'package:learning_flutter/services/mapService.dart';
import 'package:learning_flutter/state/mainStore.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
// import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    print('BUILDING GAME SCREEN!!!!!! =======================================');
    // final appState = Provider.of<MainStore>(ctx);
    MainStore appState = MainStore.getInstance();

    final mapService = MapService();
    final locationService =  LocationService();
    () async {
      // ParseUser user = await ParseUser.currentUser();
      ParseUser user = await appState.user.currentUser;
      await appState.map.fetchAllLocations();
      locationService.startStream(appState.gameSession.parseGameSession, user);
    }();

    return Scaffold(
      drawer: Drawer(child: ListView(children: [
        ListTile(title: Text('Awwww yeah!!!'),)
      ],),),
      body: Observer(builder: (_) => 
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(57.708870, 11.974560), zoom: 17),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            mapService.assignMapController(controller);
          },
          markers: appState.map.checkpointMarkers,
        ),
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end,  children: [
        // FloatingActionButton(child: Icon(Icons.add), onPressed: () => appState.map.generateSomeMarkers()),
        SizedBox(height: 10),
        FloatingActionButton(child: Icon(Icons.remove), onPressed: () => appState.map.clearAllLocations(), heroTag: null,),
        ],),
      bottomNavigationBar:

      Observer(builder: (_) =>
      Container(
        padding: EdgeInsets.all(15),
        child: 
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text('nr of timer reveals: ${appState.gameSession.nrOfRevealsFromTimer}'),
            // Text('latest location revealValue: ${appState.map.latestPreyLocation.get<bool>('revealed')}'),
            Text('future revealMoments: ${ appState.revealMoments.futureRevealMoments.length }'),
            Text('past revealMoments: ${ appState.revealMoments.pastRevealMoments.length }'),
            Text('reveal in: ${appState.revealMoments.untilNextRevealMoment.inSeconds+1}'),
            Text('elapsed: ${appState.gameSession.elapsedGameTime.inSeconds}'),
            Text('locations: ${appState.map.locations.length}'),
            Text('revealedlocations: ${appState.map.revealedPreyLocations.length}'),
            // Text('pendingLocations: ${appState.map.pendingPreyLocations.length}'),
            Text('markers: ${appState.map.checkpointMarkers.length}'),

            
              ],)
      )
        )
    );
  }
}