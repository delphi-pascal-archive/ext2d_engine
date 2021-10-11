object AboutForm: TAboutForm
  Left = 377
  Top = 238
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077' Sound Converter'
  ClientHeight = 145
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgramIcon: TImage
    Left = 25
    Top = 10
    Width = 31
    Height = 31
    AutoSize = True
  end
  object labName: TLabel
    Left = 75
    Top = 10
    Width = 181
    Height = 23
    Caption = 'Sound Converter'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object labInfo: TLabel
    Left = 10
    Top = 60
    Width = 217
    Height = 13
    Caption = #1050#1086#1085#1074#1077#1088#1090#1086#1088' '#1079#1074#1091#1082#1086#1074' '#1076#1083#1103' Ext2D Engine.'
  end
  object bev1: TBevel
    Left = 10
    Top = 55
    Width = 251
    Height = 6
    Shape = bsTopLine
  end
  object bev2: TBevel
    Left = 10
    Top = 100
    Width = 251
    Height = 6
    Shape = bsTopLine
  end
  object labAuthor: TLabel
    Left = 10
    Top = 80
    Width = 194
    Height = 13
    Caption = 'VESoft - '#1045#1089#1080#1085' '#1042#1083#1072#1076#1080#1084#1080#1088' 04.05.06'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object labVersion: TLabel
    Left = 185
    Top = 35
    Width = 73
    Height = 13
    Caption = #1042#1077#1088#1089#1080#1103' : 1.0'
  end
  object btnOK: TButton
    Left = 185
    Top = 110
    Width = 76
    Height = 26
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
end
