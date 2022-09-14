unit DocumentCardListFramePropertiesStorage;

interface

uses

  StandardDefaultObjectPropertiesStorage,
  StandardDocumentFlowInformationFramePropertiesStorage,
  unDocumentCardListFrame,
  unDocumentFlowInformationFrame,
  PropertiesIniFileUnit,
  IPropertiesStorageUnit,
  SysUtils;

type

  TDocumentCardListFramePropertiesStorage =
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

        procedure SaveDocumentCardListFrameProperties(
          DocumentCardListFrame: TDocumentCardListFrame;
          PropertiesStorage: IPropertiesStorage
        );

        procedure RestoreDocumentCardListFrameProperties(
          DocumentCardListFrame: TDocumentCardListFrame;
          PropertiesStorage: IPropertiesStorage
        );

    end;

implementation

uses

  Forms;

{ TDocumentCardListFramePropertiesStorage }

procedure TDocumentCardListFramePropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  RestoreDocumentCardListFrameProperties(
    TargetObject as TDocumentCardListFrame,
    PropertiesStorage
  );

end;

procedure TDocumentCardListFramePropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  SaveDocumentCardListFrameProperties(
    TargetObject as TDocumentCardListFrame,
    PropertiesStorage
  );

end;

procedure TDocumentCardListFramePropertiesStorage.RestoreDocumentCardListFrameProperties(
  DocumentCardListFrame: TDocumentCardListFrame;
  PropertiesStorage: IPropertiesStorage);
begin

  PropertiesStorage.GoToSection('Main');

  with DocumentCardListFrame do begin

    DocumentListPanel.Height :=
      PropertiesStorage.ReadValueForProperty(
        'TopOfSeparatorBetweenDocumentRecordsAndDocumentCard',
        varInteger,
        Height div 2
      );

  end;

end;

procedure TDocumentCardListFramePropertiesStorage.SaveDocumentCardListFrameProperties(
  DocumentCardListFrame: TDocumentCardListFrame;
  PropertiesStorage: IPropertiesStorage);
begin

  PropertiesStorage.GoToSection('Main');

  with DocumentCardListFrame do begin

    PropertiesStorage.WriteValueForProperty(
      'TopOfSeparatorBetweenDocumentRecordsAndDocumentCard',
      DocumentListPanel.Height
    );

  end;

end;

end.
