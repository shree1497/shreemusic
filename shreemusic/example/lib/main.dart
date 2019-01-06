import 'package:shreemusic/framing.dart';
import 'package:flutter/material.dart';
import 'package:shreemusic/animations.dart';
import 'dart:async';
import 'package:shreemusic/layout.dart';
import 'package:shreemusic/gestures.dart';


class DirectoryScreen extends StatelessWidget {

  static final examples = [
    {
      'title': 'Random Color Block',
      'route': '/randomColorBlock',
    },
    {
      'title': 'Overlay Layouts',
      'route': '/layoutOverlay',
    },
    {
      'title': 'Radial Gesture Detetor',
      'route': '/radialDrag',
    },
    {
      'title': 'Animation Player',
      'route': '/animationPlayer',
    }
  ];

  @override
  Widget build(BuildContext context) {

    final listItems = examples.map((example) {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new RaisedButton(
          child: new Text(
              '${example["title"]}'
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(example['route']);
          },
        ),
      );
    }).toList();

    return new ListView(
      children: listItems,
    );
  }
}



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fluttery Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => new Page(
          child: new DirectoryScreen(),
        ),
        '/randomColorBlock': (context) => new Page(
          child: new RandomColorBlockExampleScreen(),
        ),
        '/layoutOverlay': (context) => new Page(
          child: new LayoutOverlayExampleScreen(),
        ),
        '/radialDrag': (context) => new Page(
          child: new RadialDragExampleScreen(),
        ),
        '/animationPlayer': (context) => new Page(
          child: new AnimationPlayerExampleScreen(),
        ),
      },
    );
  }
}

class Page extends StatefulWidget {

  final child;

  Page({
    this.child,
  });

  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Fluttery'),
      ),
      body: widget.child,
    );
  }
}


class AnimationPlayerExampleScreen extends StatefulWidget {
  @override
  _AnimationPlayerExampleState createState() => new _AnimationPlayerExampleState();
}

class _AnimationPlayerExampleState extends State<AnimationPlayerExampleScreen> {


  double _currentPhasePosition = 0.0;

  PlayableAnimation _playableAnimation;
  // A PhaseController is only necessary if the animation that you're
  // controlling also responds to user input or some other outside force.
  PhaseController _phaseController;

  @override
  void initState() {
    super.initState();

    // This is a hard-coded PlayableAnimation which is comprised of a series
    // of "phases" that can be played forward and backward by an
    // AnimationPlayer.
    _playableAnimation = new PlayableAnimation(
      phases: [
        new Phase.uniform(
            uniformTransition: (newAnimationPercent) {
              setState(() => _currentPhasePosition = newAnimationPercent);
            }
        ),
        new Phase.bidirectional(
            forward: (forwardPercent) {
              setState(() => _currentPhasePosition = 1.0 + forwardPercent);
            },
            reverse: (reversePercent) {
              double uniformPercent = 1.0 - reversePercent;
              setState(() => _currentPhasePosition = 1.0 + uniformPercent);
            }
        ),
        new Phase.uniform(
          uniformTransition: (newAnimationPercent) {
            setState(() => _currentPhasePosition = 2.0 + newAnimationPercent);
          },
        ),
      ],
    );

    _phaseController = new PhaseController(
        phaseCount: _playableAnimation.phases.length
    );
  }

  // Increments or decrements the active phase when the user taps. This is
  // an example of how you can use the AnimationPlayer while simultaneously
  // supporting user interaction with your animation.
  _changePercentDueToUserTap() {
    int prevActivePhase = _phaseController.activePhase;
    double prevPhaseProgress = _phaseController.phaseProgress;

    if (_phaseController.playingForward) {
      _phaseController.nextPhase();

      if (prevActivePhase == _phaseController.activePhase
          && prevPhaseProgress == _phaseController.phaseProgress) {
        _phaseController.prevPhase();
      }
    } else {
      _phaseController.prevPhase();

      if (prevActivePhase == _phaseController.activePhase
          && prevPhaseProgress == _phaseController.phaseProgress) {
        _phaseController.nextPhase();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        new Center(
            child: new InkWell(
              onTap: _changePercentDueToUserTap,
              child: new Text(
                '${_currentPhasePosition.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 150.0,
                  color: Colors.black,
                ),
              ),
            )
        ),
        new Column(
          children: [
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Text(
                'Use the controls at the bottom of the screen to play each animation phase forward and backward at your desired speed.\n\nTap on the center text to manually change the phase.',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),

            new Expanded(child: new Container()),

            new AnimationPlayer(
              playableAnimation: _playableAnimation,
              phaseController: _phaseController,
            ),
          ],
        )
      ],
    );
  }
}



class RandomColorBlockExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Top Bar
          new RandomColorBlock(
            width: double.infinity,
            height: 75.0,
            child: new Center(
              child: new Container(
                padding: const EdgeInsets.all(15.0),
                color: Colors.white,
                child: new Text('Random Block Color'),
              ),
            ),
          ),

          // Square below top Bar
          new RandomColorBlock(
            width: double.infinity,
            child: new AspectRatio(
              aspectRatio: 1.0,
              child: new Center(
                child: new Container(
                  padding: const EdgeInsets.all(15.0),
                  color: Colors.white,
                  child: new Text('Random colors live across hot reloads.'),
                ),
              ),
            ),
          ),

          // Bottom bar
          new Expanded(
            child: new RandomColorBlock(
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}


class LayoutOverlayExampleScreen extends StatefulWidget {
  @override
  _LayoutOverlayExampleScreenState createState() => new _LayoutOverlayExampleScreenState();
}

class _LayoutOverlayExampleScreenState extends State<LayoutOverlayExampleScreen> {
  final fadeDuration = const Duration(milliseconds: 500);

  bool isOverlayDesired = false;
  bool isOverlayVisible = false;

  void showOverlay() {
    setState(() {
      isOverlayDesired = true;
      isOverlayVisible = true;
    });
  }

  void hideOverlay() {
    setState(() => isOverlayDesired = false);

    new Timer(
      fadeDuration,
          () => setState(() => isOverlayVisible = isOverlayDesired),
    );
  }

  Widget buildOverlay(Offset anchor) {
    return new CenterAbout(
      position: anchor,
      child: new Container(
        width: 200.0,
        child: new AnimatedOpacity(
          opacity: isOverlayDesired ? 1.0 : 0.0,
          duration: fadeDuration,
          child: new Card(
            color: Colors.white,
            child: new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Text(
                'This is an overlay!',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        // Show overlay button.
        new Expanded(
          child: new Center(
            child: new RaisedButton(
              child: new Text('Show Overlay'),
              onPressed: showOverlay,
            ),
          ),
        ),

        // Anchored overlay
        new Expanded(
          child: new AnchoredOverlay(
            showOverlay: isOverlayVisible,
            overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
              return buildOverlay(anchor);
            },
            child: new Container(
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: new Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Hide overlay button.
        new Expanded(
          child: new Center(
            child: new RaisedButton(
              child: new Text('Hide Overlay'),
              onPressed: hideOverlay,
            ),
          ),
        )
      ],
    );
  }
}


class RadialDragExampleScreen extends StatefulWidget {
  @override
  _RadialDragExampleState createState() => new _RadialDragExampleState();
}

class _RadialDragExampleState extends State<RadialDragExampleScreen> {
  bool isDragging = false;
  PolarCoord lastDragCoord;

  _onRadialDragStart(coord) {
    print('The user has started dragging radially at: $coord');
    setState(() {
      isDragging = true;
      lastDragCoord = coord;
    });
  }

  _onRadialDragUpdate(coord) {
    print('The user has dragged radially to: $coord');
    setState(() => lastDragCoord = coord);
  }

  _onRadialDragEnd() {
    print('The user has stopped dragging radially.');
    setState(() => isDragging = false);
  }

  _dragStatus() {
    if (isDragging) {
      return '$lastDragCoord';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        new Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          color: Colors.grey,
          child: new Text(
            'Drag in the space below to see the radial drag status.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        new Expanded(
          child: new RadialDragGestureDetector(
            onRadialDragStart: _onRadialDragStart,
            onRadialDragUpdate: _onRadialDragUpdate,
            onRadialDragEnd: _onRadialDragEnd,
            child: new Center(
              child: new Container(
                color: Colors.white, // without a color the Container seems to collapse
                child: new Align(
                  alignment: Alignment.center,
                  child: new Text(
                    _dragStatus(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
