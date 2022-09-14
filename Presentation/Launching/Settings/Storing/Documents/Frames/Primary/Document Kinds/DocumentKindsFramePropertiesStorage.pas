unit DocumentKindsFramePropertiesStorage;

interface

uses

  StandardDefaultObjectPropertiesStorage,
  StandardDocumentFlowInformationFramePropertiesStorage,
  unDocumentFlowInformationFrame,
  PropertiesIniFileUnit,
  unDocumentKindsFrame,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  TDocumentKindsFramePropertiesStorage =
    class (TStandardDocumentFlowInformationFramePropertiesStorage)

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

        procedure RestoreDocumentKindsFrameProperties(
          DocumentKindsFrame: TDocumentKindsFrame;
          PropertiesStorage: IPropertiesStorage
        );

        procedure SaveDocumentKindsFrameProperties(
          DocumentKindsFrame: TDocumentKindsFrame;
          PropertiesStorage: IPropertiesStorage
        ); 

    end;

implementation

uses

  Variants,
  UIDocumentKinds;

{ TDocumentKindsFramePropertiesStorage }

procedure TDocumentKindsFramePropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  RestoreDocumentKindsFrameProperties(
    TargetObject as TDocumentKindsFrame,
    PropertiesStorage
  );

end;

procedure TDocumentKindsFramePropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  SaveDocumentKindsFrameProperties(
    TargetObject as TDocumentKindsFrame,
    PropertiesStorage
  );

end;

procedure TDocumentKindsFramePropertiesStorage.RestoreDocumentKindsFrameProperties(
  DocumentKindsFrame: TDocumentKindsFrame;
  PropertiesStorage: IPropertiesStorage
);
var
    RestoredCurrentDocumentKindId: Variant;
begin

  PropertiesStorage.GoToSection('Main');

  RestoredCurrentDocumentKindId :=
    PropertiesStorage.ReadValueForProperty(
      'CurrentDocumentKindSection',
      varVariant,
      Null
    );

  with DocumentKindsFrame do begin

    if not VarIsNull(RestoredCurrentDocumentKindId) then
        CurrentDocumentKindId := RestoredCurrentDocumentKindId

    else CurrentUIDocumentKind := TUIOutcomingServiceNoteKind;

  end;

end;

procedure TDocumentKindsFramePropertiesStorage.SaveDocumentKindsFrameProperties(
  DocumentKindsFrame: TDocumentKindsFrame;
  PropertiesStorage: IPropertiesStorage);
begin

  PropertiesStorage.GoToSection('Main');

  with DocumentKindsFrame do begin

    PropertiesStorage.WriteValueForPropertyAsVariant(
      'CurrentDocumentKindSection', CurrentDocumentKindId
    );

  end;

end;

end.
