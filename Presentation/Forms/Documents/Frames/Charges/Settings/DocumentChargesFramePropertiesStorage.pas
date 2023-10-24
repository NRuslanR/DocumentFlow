unit DocumentChargesFramePropertiesStorage;

interface

uses

  StandardDefaultObjectPropertiesStorage,
  StandardDocumentFlowInformationFramePropertiesStorage,
  unDocumentFlowInformationFrame,
  unDocumentChargesFrame,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  TDocumentChargesFramePropertiesStorage =
    class abstract (TStandardDocumentFlowInformationFramePropertiesStorage)

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

        procedure SaveDocumentChargesFrameProperties(
          DocumentChargesFrame: TDocumentChargesFrame;
          PropertiesStorage: IPropertiesStorage
        );

        procedure SaveDocumentChargesTreeListProperties(
          DocumentChargesFrame: TDocumentChargesFrame;
          PropertiesStorage: IPropertiesStorage
        ); virtual; abstract;

      protected

        procedure RestoreDocumentChargesFrameProperties(
          DocumentChargesFrame: TDocumentChargesFrame;
          PropertiesStorage: IPropertiesStorage
        );

        procedure RestoreDocumentChargesTreeListProperties(
          DocumentChargesFrame: TDocumentChargesFrame;
          PropertiesStorage: IPropertiesStorage
        ); virtual; abstract;

    end;

implementation


{ TDocumentChargesFramePropertiesStorage }

procedure TDocumentChargesFramePropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  RestoreDocumentChargesFrameProperties(
    TargetObject as TDocumentChargesFrame,
    PropertiesStorage
  );

end;

procedure TDocumentChargesFramePropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  SaveDocumentChargesFrameProperties(
    TargetObject as TDocumentChargesFrame,
    PropertiesStorage
  );

end;

procedure TDocumentChargesFramePropertiesStorage.RestoreDocumentChargesFrameProperties(
  DocumentChargesFrame: TDocumentChargesFrame;
  PropertiesStorage: IPropertiesStorage);
begin

  RestoreDocumentChargesTreeListProperties(DocumentChargesFrame, PropertiesStorage);

end;

procedure TDocumentChargesFramePropertiesStorage.SaveDocumentChargesFrameProperties(
  DocumentChargesFrame: TDocumentChargesFrame;
  PropertiesStorage: IPropertiesStorage);
begin

  SaveDocumentChargesTreeListProperties(DocumentChargesFrame, PropertiesStorage);
  
end;

end.
