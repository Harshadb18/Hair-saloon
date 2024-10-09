import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  final String category;
  final String imagepath;
  final VoidCallback onTap;

  const CategoryContainer(
      this.category,
      this.imagepath,
      this.onTap, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[200]!],
          ),
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  imagepath,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 24,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
