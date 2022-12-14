import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalTextField extends StatefulWidget {

  GlobalTextField({
    Key? key,
    this.contentPadding,
    this.title,
    this.hint,
    this.security = false,
    this.controller,
    this.textInputType,
    this.validator,
    this.autovalidateMode,
    this.requireInput = '*',
    this.readOnly,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.inputFormatters,
    this.onSubmit,
    this.enabled,
  }) : super(key: key);

  final Widget? prefixIcon;
  Widget? suffixIcon;
  final bool? readOnly;
  final GestureTapCallback? onTap;
  final TextInputType? textInputType;
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  bool security;
  final FormFieldValidator? validator;
  final AutovalidateMode? autovalidateMode;
  final String requireInput;
  final int maxLines;
  final int minLines;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String value)? onSubmit;
  final bool? enabled;

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {

  bool secure = false;

  @override
  void initState() {
    super.initState();
    if (widget.security) {
      if (widget.suffixIcon == null) {
        secure = true;
      }
      widget.suffixIcon ??= TextButton(
        onPressed: () {
          setState(() {
            widget.security = !widget.security;
          });
        },
        child: Visibility(
          visible: widget.security,
          child: const Icon(Icons.visibility, color: Colors.grey,),
          replacement: const Icon(Icons.visibility_off, color: Colors.grey,),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (secure) {
      widget.suffixIcon = TextButton(
        onPressed: () {
          setState(() {
            widget.security = !widget.security;
          });
        },
        child: Visibility(
          visible: widget.security,
          child: const Icon(Icons.visibility, color: Colors.black54,),
          replacement: const Icon(Icons.visibility_off, color: Colors.black54,),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: '${widget.title ?? ''}${widget.requireInput}'.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title??'',
                style: TextStyle(
                  fontSize: 12,

                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        TextFormField(
          autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          expands: false,
          controller: widget.controller,
          obscureText: widget.security,
          keyboardType: widget.textInputType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hint ?? '',
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            contentPadding: widget.contentPadding,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent
              )
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.transparent
                )
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.transparent
                )
            )
          ),
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          validator: widget.validator,
          onTap: widget.onTap,
          readOnly: widget.readOnly ?? false,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters
              ?? (TextInputType.phone == widget.textInputType ? [LengthLimitingTextInputFormatter(10)] : null),
          onFieldSubmitted: widget.onSubmit,
        ),
      ],
    );
  }
}

// class Validator {
//   static String? serial(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p m?? serial';
//     }
//     if (!RegExp(r'[0-9]').hasMatch(value)) {
//       return 'Vui l??ng nh???p m?? serial l?? s??? t??? 0-9';
//     }
//     return null;
//   }
//
//
//   static String? pointCanEmpty(valueDy, {int? maxPoint, int? minPoint}) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return null;
//     }
//     return point(valueDy, maxPoint: maxPoint, minPoint: minPoint);
//   }
//
//   static String? point(valueDy, {int? maxPoint, int? minPoint}) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p ??i???m';
//     }
//     if (!RegExp(r'[0-9]')
//         .hasMatch(value)) {
//       return 'Vui l??ng nh???p ??i???m l?? s??? t??? 0-9';
//     }
//     if (null != maxPoint) {
//       int point = int.parse(value);
//       if (point > maxPoint) {
//         return 'Vui l??ng nh???p ??i???m <=$maxPoint';
//       }
//     }
//     if (null != minPoint) {
//       int point = int.parse(value);
//       if (point < minPoint) {
//         return 'Vui l??ng nh???p ??i???m >=$minPoint';
//       }
//     }
//     return null;
//   }
//
//   static String? tax(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p m?? s??? thu???';
//     }
//     return null;
//   }
//
//   static String? fullnameCompany(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p t??n c??ng ty';
//     }
//     return null;
//   }
//
//
//   static String? fullnameCanEmpty(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return null;
//     }
//     return fullname(valueDy);
//   }
//
//   static String? emailCanEmpty(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return null;
//     }
//     return email(valueDy);
//   }
//
//   static String? productName(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p t??n s???n ph???m';
//     }
//     return null;
//   }
//
//   static String? bank(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p s??? t??i kho???n ng??n h??ng';
//     }
//     return null;
//   }
//
//   static String? bankName(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p h??? t??n ch??? t??i kho???n ng??n h??ng';
//     }
//     return null;
//   }
//
//   static String? address(valueDy) {
//     String value = valueDy;
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p ?????a ch??? c??? th???';
//     }
//     return null;
//   }
//
//   static String? idCard(valueDy) {
//     String value = valueDy;
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p s??? CMND/ CCCD';
//     }
//     if (value.length != 9 && value.length != 12) {
//       return 'Vui l??ng nh???p ????? 9 ho???c 12 s??? CMND/ CCCD';
//     }
//     return null;
//   }
//
//   static String? email(valueDy) {
//     String value = valueDy;
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p email';
//     }
//     if (!RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$").hasMatch(value)) {
//       return 'Vui l??ng nh???p ????ng email';
//     }
//     return null;
//   }
//
//
//   static String? birthday(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng ch???n ng??y sinh';
//     }
//     if (!RegExp(r'\d{4}.\d{2}.\d{2}').hasMatch(value)) {
//       return 'Vui l??ng nh???p ng??y theo ?????nh d???ng "yyyy-MM-dd"';
//     }
//     return null;
//   }
//
//   static String? birthdayVn(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng ch???n ng??y sinh';
//     }
//     if (!RegExp(r'\d{2}.\d{2}.\d{4}').hasMatch(value)) {
//       return 'Vui l??ng nh???p ng??y theo ?????nh d???ng "dd/MM/yyyy"';
//     }
//     return null;
//   }
//
//   static String? birthdayVnCanEmpty(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return null;
//     }
//     return birthdayVn(valueDy);
//   }
//
//   static String? referralCode(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p m?? ng?????i gi???i thi???u';
//     }
//     return null;
//   }
//
//   static String? fullname(valueDy) {
//     String value = valueDy ?? '';
//     if (value.isEmpty) {
//       return 'Vui l??ng nh???p h??? v?? t??n';
//     }
//     if (!RegExp(r'\w+').hasMatch(value)) {
//       return 'Vui l??ng nh???p ????ng h??? v?? t??n';
//     }
//     return null;
//   }
//
//   // static String? phone(valueDy) {
//   //   String value = valueDy ?? '';
//   //   if (value.isEmpty) {
//   //     return 'Vui l??ng nh???p s??? ??i???n tho???i Vi???t Nam';
//   //   }
//   //   if (value.trim().length != 10) {
//   //     return 'Vui l??ng nh???p ????ng 10 s??? ??i???n tho???i';
//   //   }
//   //   if (!RegExp(r'^0?[3|5|7|8|9][0-9]{8}$')
//   //       .hasMatch(value)) {
//   //     return 'Vui l??ng nh???p ????ng s??? ??i???n tho???i Vi???t Nam';
//   //   }
//   //   return null;
//   // }
//   //
//   // static String? password(valueDy) {
//   //   String value = valueDy ?? '';
//   //   if (value.length < 8) {
//   //     return 'Vui l??ng nh???p m???t kh???u ??t nh???t 8 k?? t???';
//   //   }
//   //   if (!RegExp(r'[a-z]').hasMatch(value)) {
//   //     return 'Vui l??ng nh???p ??t nh???t 1 k?? t??? th?????ng';
//   //   }
//   //   if (!RegExp(r'[A-Z]').hasMatch(value)) {
//   //     return 'Vui l??ng nh???p ??t nh???t 1 k?? t??? in hoa';
//   //   }
//   //   if (!RegExp(r'[0-9]').hasMatch(value)) {
//   //     return 'Vui l??ng nh???p ??t nh???t 1 s??? t??? 0 ?????n 9';
//   //   }
//   //   if (!RegExp(r'[!"#$%&'"'"'()*+,-./:;<=>?@[\\]^_`{|}~]').hasMatch(value)) {
//   //     return 'Vui l??ng nh???p ??t nh???t 1 k?? t??? ?????c bi???t';
//   //   }
//   //   return null;
//   // }
//   //
//   // static String? rePassword(valueDy, String rePassword) {
//   //   String value = valueDy ?? '';
//   //   if (value.isEmpty) {
//   //     return 'Vui l??ng x??c nh???n l???i m???t kh???u';
//   //   }
//   //   if (value != rePassword) {
//   //     return 'M???t kh???u x??c nh???n kh??ng kh???p';
//   //   }
//   //   return null;
//   // }
//
// }
