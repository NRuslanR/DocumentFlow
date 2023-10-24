unit DocumentChargesFramePropertiesIniFile;

interface

uses

  DocumentChargesFramePropertiesStorage,
  unDocumentFlowInformationFrame,
  unDocumentChargesFrame,
  IPropertiesStorageUnit,
  PropertiesIniFileUnit,
  SysUtils,
  Classes;

type

  TDocumentChargesFramePropertiesIniFile =
    class (TDocumentChargesFramePropertiesStorage)

      protected

        FIsFailedRestoreAttemptAlreadyOccurred: Boolean;
        
      protected

        procedure SaveDocumentChargesTreeListProperties(
          DocumentChargesFrame: TDocumentChargesFrame;
          PropertiesStorage: IPropertiesStorage
        ); override;

        procedure RestoreDocumentChargesTreeListProperties(
          DocumentChargesFrame: TDocumentChargesFrame;
          PropertiesStorage: IPropertiesStorage
        ); override;

      public
      
        constructor Create(
          const IniFilePath: String;
          const DefaultIniFilePath: String = ''
        );
      
    end;

implementation

uses

  AuxWindowsFunctionsUnit,
  AuxDebugFunctionsUnit;

{ TDocumentChargesFramePropertiesIniFile }

constructor TDocumentChargesFramePropertiesIniFile.Create(
  const IniFilePath: String;
  const DefaultIniFilePath: String
);
var
    DefaultPropertiesStorage: IPropertiesStorage;
begin

  if Trim(DefaultIniFilePath) <> '' then
    DefaultPropertiesStorage := TPropertiesIniFile.Create(DefaultIniFilePath, True, False)

  else DefaultPropertiesStorage := nil;

  inherited Create(
    TPropertiesIniFile.Create(IniFilePath, True, False),
    DefaultPropertiesStorage
  );
  
end;

procedure TDocumentChargesFramePropertiesIniFile.RestoreDocumentChargesTreeListProperties(
  DocumentChargesFrame: TDocumentChargesFrame;
  PropertiesStorage: IPropertiesStorage
);
begin

  try

    with TPropertiesIniFile(PropertiesStorage.Self) do begin

      if not RaiseExceptionIfIniFileNotExists and not FileExists(IniFilePath) then Exit;

      DocumentChargesFrame.ChargeTreeList.RestoreFromIniFile(IniFilePath);

    end;

  except

    on E: Exception do begin

      if not FIsFailedRestoreAttemptAlreadyOccurred then begin

        FIsFailedRestoreAttemptAlreadyOccurred := True;

        ShowWarningMessage(
          DocumentChargesFrame.Handle,
          'Ќе удалось восстановить свойства дл€ ' +
          'области поручений в карточке документа',
          '—ообщение'
        );

      end;

    end;

  end;


end;

procedure TDocumentChargesFramePropertiesIniFile.SaveDocumentChargesTreeListProperties(
  DocumentChargesFrame: TDocumentChargesFrame;
  PropertiesStorage: IPropertiesStorage);
begin

  with TPropertiesIniFile(PropertiesStorage.Self) do begin

    DocumentChargesFrame.ChargeTreeList.StoreToIniFile(IniFilePath);

  end;

end;

end.
