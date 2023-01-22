import 'package:flutter/material.dart';
import 'package:gitshiwam/app/global.dart';
import 'package:gitshiwam/service/auth_service.dart';


Duration defaultAnimDuration = const Duration(milliseconds: 250);
Duration transitionAnimDuration = const Duration(milliseconds: 500);
BorderRadius smallBorderRadius = BorderRadius.circular(5.0);
BorderRadius medBorderRadius = BorderRadius.circular(10.0);
BorderRadius bigBorderRadius = BorderRadius.circular(15.0);

class ScaleExpandedSection extends StatefulWidget {
  const ScaleExpandedSection(
      {this.expand = true,
        this.child,
        this.animationCurve,
        this.duration,
        Key? key})
      : super(key: key);
  final Widget? child;
  final bool expand;
  final Curve? animationCurve;
  final Duration? duration;

  @override
  _ScaleExpandedSectionState createState() => _ScaleExpandedSectionState();
}

class _ScaleExpandedSectionState extends State<ScaleExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  //Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration:
        widget.duration ?? transitionAnimDuration);
    animation = CurvedAnimation(
      parent: expandController,
      curve: widget.animationCurve ?? Curves.fastOutSlowIn,
    );
    if (widget.expand) {
      _runExpandCheck();
    }
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ScaleExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: widget.child,
    );
  }
}


class SizeExpandedSection extends StatefulWidget {
  const SizeExpandedSection(
      {this.expand = true,
        this.child,
        this.axisAlignment = 1.0,
        this.axis = Axis.vertical,
        this.duration,
        this.animationCurve,
        Key? key})
      : super(key: key);
  final Widget? child;
  final bool? expand;
  final Axis axis;
  final double axisAlignment;
  final Curve? animationCurve;
  final Duration? duration;

  @override
  _SizeExpandedSectionState createState() => _SizeExpandedSectionState();
}

class _SizeExpandedSectionState extends State<SizeExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: widget.duration ?? transitionAnimDuration);
    animation = CurvedAnimation(
      parent: expandController,
      curve: widget.animationCurve ?? Curves.fastOutSlowIn,
    );
    if (widget.expand!) {
      _runExpandCheck();
    }
  }

  void _runExpandCheck() {
    if (widget.expand!) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(SizeExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: widget.axisAlignment,
      sizeFactor: animation,
      axis: widget.axis,
      child: widget.child,
    );
  }
}



class FutureAPIBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final AsyncWidgetBuilder<T>? initialData;
  final builder;

  const FutureAPIBuilder({
    Key? key,
    this.future,
    this.initialData,
    required this.builder,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<T>(
      key: key,
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot){
        // check if auth error has occured
        if(snapshot.connectionState == ConnectionState.done && snapshot.error != null){
          // Error error = snapshot.error;
          bool logout = false;
          logout = errorResolverShouldLogout(snapshot.error);
          if(logout){
            return const ForceLogoutAlertDialogue("Session expired");
          }
        }
        return builder(context, snapshot);
      },
    );
  }

  bool errorResolverShouldLogout(error) {
    //Todo
    //returning false as of now
    //Will check expiretoken error here then will return the value according to that
    return true;
  }

}

class ForceLogoutAlertDialogue extends StatefulWidget {
  final String titleMessage;
  const ForceLogoutAlertDialogue(this.titleMessage,{Key? key,}) : super(key: key);

  @override
  State<ForceLogoutAlertDialogue> createState() => _ForceLogoutAlertDialogueState();
}

class _ForceLogoutAlertDialogueState extends State<ForceLogoutAlertDialogue> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      logOutApp(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        height: 180,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(8),
              height: 40,
              child: Text(widget.titleMessage,overflow: TextOverflow.clip, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            ),
            const SizedBox(height: 35,),
            const Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 15,),
            const Center(
              child: Text("logging out...", style: TextStyle(color: Colors.black, fontSize: 14),),
            )
          ],
        ),
      ),
    );
  }
}

void logOutApp(BuildContext context, {String? message}) {
  AuthService.logOut();
  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
}


