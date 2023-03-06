unit unApplicationDataModule;

interface

uses
  SysUtils, Classes, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZConnection, ZSqlUpdate;

type

  TDatabaseConnectionResult = (

    SuccessConnection,
    ConnectionCanceledByUser,
    FailedConnection

  );

  TDocumentFlowAppDataModule = class(TDataModule)

    private

      FDBConnection: TZConnection;

      procedure SetDBConnection(const Value: TZConnection);

    public

      constructor Create(AOwner: TComponent); override;

      function EstablishConnectionWithDatabase(
        var ConnectionResult: TDatabaseConnectionResult
      ): TZConnection;

      property Connection: TZConnection
      read FDBConnection write SetDBConnection;
    
  end;

var
  DocumentFlowAppDataModule: TDocumentFlowAppDataModule;

implementation

uses

  LoginFrm,
  Forms,
  AuxDebugFunctionsUnit;

{$R *.dfm}

{ TApplicationDataModule }

constructor TDocumentFlowAppDataModule.Create(AOwner: TComponent);
begin

  inherited;

  FDBConnection := TZConnection.Create(Self);
  
end;

function TDocumentFlowAppDataModule.EstablishConnectionWithDatabase(
  var ConnectionResult: TDatabaseConnectionResult
): TZConnection;
begin

  try

    if GetConnected(FDBConnection) then begin

      Result := FDBConnection;
      ConnectionResult := SuccessConnection;

    end

    else begin

      Result := nil;
      ConnectionResult := ConnectionCanceledByUser;

    end;

  except

    on e: Exception do begin

      ConnectionResult := FailedConnection;
      raise;
      
    end;

  end;

end;

procedure TDocumentFlowAppDataModule.SetDBConnection(const Value: TZConnection);
begin

  if FDBConnection = Value then Exit;
  
  FreeAndNil(FDBConnection);

  FDBConnection := Value;

end;

end.
