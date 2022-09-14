unit ApplicationLauncher;

interface

uses

  SysUtils,
  Classes,
  Windows,
  ConfigurationData,
  UIApplicationConfigurator,
  IObjectPropertiesStorageRegistryUnit;

type

  TDabatabseConnectionCanceledByUserException = class (Exception)

  end;
  
  TApplicationLauncher = class

    private

      FUIApplicationConfigurator: TUIApplicationConfigurator;

      procedure InitializeApplicationModule;

      procedure Configure;

      function EstablishConnectionWithDatabase: TComponent;

      procedure PassControlToApplicationModule;

    public

      destructor Destroy; override;
      
      constructor Create(ApplicationConfigurator: TUIApplicationConfigurator);

      procedure Launch;

  end;

implementation

uses

  DB,
  Graphics,
  AuxDebugFunctionsUnit,
  AuxZeosFunctions,
  AuxDataSetFunctionsUnit,
  AuxWindowsFunctionsUnit,
  Forms,
  unApplicationDataModule,
  WorkingEmployeeUnit;

{ TApplicationLauncher }

procedure TApplicationLauncher.Configure;
var DatabaseConnection: TComponent;
    ConfigurationData: TConfigurationData;
begin

  ConfigurationData := TConfigurationData.Create;

  try

    ConfigurationData.DatabaseConnection := EstablishConnectionWithDatabase;

    FUIApplicationConfigurator.Configure(
      ConfigurationData
    );

  finally

    FreeAndNil(ConfigurationData);
    
  end;

end;

constructor TApplicationLauncher.Create(
  ApplicationConfigurator: TUIApplicationConfigurator);
begin

  inherited Create;

  FUIApplicationConfigurator := ApplicationConfigurator;
  
end;

destructor TApplicationLauncher.Destroy;
begin

  FreeAndNil(FUIApplicationConfigurator);
  
  inherited;

end;

function TApplicationLauncher.EstablishConnectionWithDatabase: TComponent;
var DBConnection: TComponent;
    DatabaseConnectionResult: TDatabaseConnectionResult;
begin

  Application.CreateForm(TDocumentFlowAppDataModule, DocumentFlowAppDataModule);

  Result := DocumentFlowAppDataModule.EstablishConnectionWithDatabase(
                    DatabaseConnectionResult
                  );

  if DatabaseConnectionResult = ConnectionCanceledByUser then
    raise TDabatabseConnectionCanceledByUserException.Create('');

end;

procedure TApplicationLauncher.InitializeApplicationModule;
begin

  Application.Initialize;

end;

procedure TApplicationLauncher.PassControlToApplicationModule;
begin

  Application.Run;

  Application.MainForm.Free;

end;

procedure TApplicationLauncher.Launch;
begin

  try

    InitializeApplicationModule;
    Configure;
    PassControlToApplicationModule;

  except

    on e: Exception do begin

      if not (e is TDabatabseConnectionCanceledByUserException) then
        Raise;
      
    end;

  end;

end;

end.
