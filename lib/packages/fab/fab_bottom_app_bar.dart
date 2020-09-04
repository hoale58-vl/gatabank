import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  final String text;
  final normalImage;
  final selectedImage;
  final TextStyle regularStyle;
  final TextStyle selectedStyle;

  FABBottomAppBarItem(
      {this.text, this.normalImage, this.selectedImage, this.regularStyle, this.selectedStyle});
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar(
      {this.items,
        this.centerItemText,
        this.height: 60.0,
        this.iconSize: 20.0,
        this.backgroundColor,
        this.color,
        this.selectedColor,
        this.notchedShape,
        this.onTabSelected,
        this.initialSelectedIndex}) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final int initialSelectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.initialSelectedIndex;
    super.initState();
  }

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
      elevation: 30,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 1,
                    width: 60,
                    child: Container(
                      color: _selectedIndex == index ? widget.selectedColor : widget.color,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: _selectedIndex == index ? item.selectedImage : item.normalImage,
                ),
                Expanded(
                  flex: 10,
                  child: Text(
                    item.text,
                    style: (_selectedIndex == index) ? item.selectedStyle : item.regularStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
