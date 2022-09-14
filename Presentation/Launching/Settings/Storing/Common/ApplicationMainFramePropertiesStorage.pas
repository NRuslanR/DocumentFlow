unit ApplicationMainFramePropertiesStorage;

interface

uses

  StandardDefaultObjectPropertiesStorage,
  unApplicationMainFrame,
  unApplicationMainForm,
  IPropertiesStorageUnit,
  UserInterfaceSwitch,
  SysUtils,
  Graphics,
  Windows,
  Classes;

type

  TApplicationMainFramePropertiesStorage =
    class abstract (TStandardDefaultObjectPropertiesStorage)

      protected

        procedure InternalSaveObjectProperties(
          TargetObject: TObject;
          PropertiesStorage: IPropertiesStorage
        ); override;

        procedure InternalRestorePropertiesForObject(
          TargetObject: TObject;
          PropertiesStorage: IPropertiesStorage
        ); override;

      protected

        procedure SaveApplicationMainFrameProperties(
          ApplicationMainFrame: TApplicationMainFrame;
          PropertiesStorage: IPropertiesStorage
        );

        procedure RestoreApplicationMainFrameProperties(
          ApplicationMainFrame: TApplicationMainFrame;
          PropertiesStorage: IPropertiesStorage
        );

      protected

        procedure RestoreFontSettings(Font: TFont; PropertiesStorage: IPropertiesStorage);
        procedure SaveFontSettings(Font: TFont; PropertiesStorage: IPropertiesStorage);

    end;
  
implementation

uses

  Forms,
  PropertiesIniFileUnit,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  AuxiliaryStringFunctions;

{ TApplicationMainFramePropertiesStorage }

procedure TApplicationMainFramePropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  RestoreApplicationMainFrameProperties(
    TargetObject as TApplicationMainFrame,
    PropertiesStorage
  );

end;

procedure TApplicationMainFramePropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  SaveApplicationMainFrameProperties(
    TargetObject as TApplicationMainFrame,
    PropertiesStorage
  );

end;

procedure TApplicationMainFramePropertiesStorage.RestoreApplicationMainFrameProperties(
  ApplicationMainFrame: TApplicationMainFrame;
  PropertiesStorage: IPropertiesStorage);
var
    AppFont: TFont;
    LeftOfSeparatorBetweenDocumentTypesAndRest: Integer;
    TopOfSeparatorBetweenDocumentRecordsAndDocumentCard: Integer;
    DefaultTopOfSeparatorBetweenDocumentRecordsAndDocumentCard: Integer;
    AppMainForm: TApplicationMainForm;
    IsNewUISelected: Boolean;
begin
              
  PropertiesStorage.GoToSection('Main');

  LeftOfSeparatorBetweenDocumentTypesAndRest :=
    PropertiesStorage.ReadValueForProperty(
      'LeftOfSeparatorBetweenDocumentTypesAndRest',
      varInteger,
      281
    );

  ApplicationMainFrame.DocumentKindsFrameArea.Width :=
    LeftOfSeparatorBetweenDocumentTypesAndRest;

  AppFont := ApplicationMainFrame.Font;

  RestoreFontSettings(AppFont, PropertiesStorage);

  ApplicationMainFrame.Font := AppFont;

  Application.MainForm.Font := AppFont;

  if PropertiesStorage <> FDefaultPropertiesStorage then begin

    ApplicationMainFrame.UserInterfaceKind :=
      PropertiesStorage.ReadValueForProperty(
        'UserInterfaceKind',
        varInteger,
        uiOld
      );

  end;

  AppMainForm := TApplicationMainForm(Application.MainForm);

  IsNewUISelected := ApplicationMainFrame.UserInterfaceKind = uiNew;

  with AppMainForm do begin

    SetOldUITool.Checked := not IsNewUISelected;
    SetNewUITool.Checked := IsNewUISelected;

  end;
   
end;

procedure TApplicationMainFramePropertiesStorage.RestoreFontSettings(
  Font: TFont; PropertiesStorage: IPropertiesStorage);
var
    FontStylesString: String;
    FontStyleStrings: TStrings;
    FontStyleString: String;
begin

  Font.Size :=
    PropertiesStorage.ReadValueForProperty('FontSize', varInteger, 8);

  Font.Name :=
    PropertiesStorage.ReadValueForProperty('FontName', varString, 'Arial');

  Font.Color :=
    PropertiesStorage.ReadValueForProperty('FontColor', varInteger, clDefault);

  FontStylesString :=
    PropertiesStorage.ReadValueForProperty('FontStyle', varString, '');

  if FontStylesString <> '' then begin

    FontStyleStrings := SplitStringByDelimiter(FontStylesString, ',');

    for FontStyleString in FontStyleStrings do
      Font.Style := Font.Style + [TFontStyle(StrToInt(FontStyleString))];
    
  end;

end;

procedure TApplicationMainFramePropertiesStorage.SaveApplicationMainFrameProperties(
  ApplicationMainFrame: TApplicationMainFrame;
  PropertiesStorage: IPropertiesStorage);
var
    LeftOfSeparatorBetweenDocumentTypesAndRest: Integer;
    TopOfSeparatorBetweenDocumentRecordsAndDocumentCard: Integer;
    UserInterfaceKind: TUserInterfaceKind;
begin

  PropertiesStorage.GoToSection('Main');

  LeftOfSeparatorBetweenDocumentTypesAndRest :=
    ApplicationMainFrame.DocumentKindsFrameArea.Width;

  PropertiesStorage.WriteValueForProperty(
    'LeftOfSeparatorBetweenDocumentTypesAndRest',
    LeftOfSeparatorBetweenDocumentTypesAndRest
  );

  SaveFontSettings(ApplicationMainFrame.Font, PropertiesStorage);

  UserInterfaceKind := ApplicationMainFrame.UserInterfaceKind;

  PropertiesStorage.WriteValueForProperty(
    'UserInterfaceKind',
    UserInterfaceKind
  );

end;

procedure TApplicationMainFramePropertiesStorage.SaveFontSettings(Font: TFont; PropertiesStorage: IPropertiesStorage);
var FontStylesString: String;
    FontStyleString: String;
    FontStyle: TFontStyle;
begin

  PropertiesStorage.WriteValueForProperty(
    'FontSize', Font.Size
  );

  for FontStyle in Font.Style do begin

    FontStyleString := IntToStr(Integer(FontStyle));
    
    if FontStylesString = '' then
      FontStylesString := FontStyleString

    else
      FontStylesString := FontStylesString + ',' + FontStyleString;
    
  end;

  PropertiesStorage.WriteValueForProperty(
    'FontStyle', FontStylesString
  );                                    

  PropertiesStorage.WriteValueForProperty(
    'FontName', Font.Name
  );

  PropertiesStorage.WriteValueForProperty(
    'FontColor', Font.Color
  );

end;

end.
