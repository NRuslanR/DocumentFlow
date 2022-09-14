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
    DBConnection: TZConnection;


  public

    function EstablishConnectionWithDatabase(
      var ConnectionResult: TDatabaseConnectionResult
    ): TZConnection;
    
    property Connection: TZConnection
    read DBConnection write DBConnection;
    
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

function TDocumentFlowAppDataModule.EstablishConnectionWithDatabase(
  var ConnectionResult: TDatabaseConnectionResult
): TZConnection;
begin

  try

    if GetConnected(DBConnection) then begin

      Result := DBConnection;
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

end.
