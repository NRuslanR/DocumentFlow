unit DocumentRecordsPanelSettingsFormPropertiesStorage;

interface

uses

  IObjectPropertiesStorageUnit,
  StandardDefaultObjectPropertiesStorage,
  DocumentRecordsPanelSettingsFormUnit,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

const

  DOCUMENT_RECORDS_PANEL_SETTINGS_SECTION_NAME = 'DocumentRecordsPanelSettings';
  ENABLE_RECORD_GROUPING_BY_COLUMNS_OPTION_SETTING_NAME = 'EnableRecordGroupingByColumnsOption';

type

  TDocumentRecordsPanelSettingsFormPropertiesStorage =
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

        procedure SaveDocumentRecordsPanelSettingsFormProperties(
          DocumentRecordsPanelSettingsForm: TDocumentRecordsPanelSettingsForm;
          PropertiesStorage: IPropertiesStorage
        ); 

        procedure RestoreDocumentRecordsPanelSettingsFormProperties(
          DocumentRecordsPanelSettingsForm: TDocumentRecordsPanelSettingsForm;
          PropertiesStorage: IPropertiesStorage
        );

    end;

implementation

{ TDocumentRecordsPanelSettingsFormPropertiesStorage }

procedure TDocumentRecordsPanelSettingsFormPropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject;
  PropertiesStorage: IPropertiesStorage
);
begin

  RestoreDocumentRecordsPanelSettingsFormProperties(
    TargetObject as TDocumentRecordsPanelSettingsForm,
    PropertiesStorage
  );

end;

procedure TDocumentRecordsPanelSettingsFormPropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject;
  PropertiesStorage: IPropertiesStorage
);
begin

  SaveDocumentRecordsPanelSettingsFormProperties(
    TargetObject as TDocumentRecordsPanelSettingsForm,
    PropertiesStorage
  );

end;

procedure TDocumentRecordsPanelSettingsFormPropertiesStorage.
  RestoreDocumentRecordsPanelSettingsFormProperties(
    DocumentRecordsPanelSettingsForm: TDocumentRecordsPanelSettingsForm;
    PropertiesStorage: IPropertiesStorage
  );
begin

  PropertiesStorage.GoToSection(
    DOCUMENT_RECORDS_PANEL_SETTINGS_SECTION_NAME
  );

  DocumentRecordsPanelSettingsForm.
    EnableDocumentRecordGroupingByColumnsOption :=

      PropertiesStorage.ReadValueForProperty(
        ENABLE_RECORD_GROUPING_BY_COLUMNS_OPTION_SETTING_NAME,
        varBoolean,
        False
      );

end;

procedure TDocumentRecordsPanelSettingsFormPropertiesStorage.SaveDocumentRecordsPanelSettingsFormProperties(
  DocumentRecordsPanelSettingsForm: TDocumentRecordsPanelSettingsForm;
  PropertiesStorage: IPropertiesStorage
);
begin

  PropertiesStorage.GoToSection(DOCUMENT_RECORDS_PANEL_SETTINGS_SECTION_NAME);

  PropertiesStorage.WriteValueForProperty(
    ENABLE_RECORD_GROUPING_BY_COLUMNS_OPTION_SETTING_NAME,
    DocumentRecordsPanelSettingsForm.EnableDocumentRecordGroupingByColumnsOption
  );
  
end;

end.
