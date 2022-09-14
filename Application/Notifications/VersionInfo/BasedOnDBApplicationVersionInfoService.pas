unit BasedOnDBApplicationVersionInfoService;

interface

uses
  ApplicationVersionInfoService,
  AbstractApplicationService,
  PropertiesIniFileUnit,
  VersionInfoDTOs,
  QueryExecutor,
  DataReader,
  DB,
  SysUtils;

const
  VERSION_ID_FIELD = 'id';
  VERSION_NUMBER_FIELD = 'version_nbr';
  VERSION_DATE_FIELD = 'version_date';
  VERSION_DESCRIPTION_FIELD = 'description';
  VERSION_FILE_PATH_FIELD = 'file_path';
  VERSION_VISIBLE_FIELD = 'is_visible';

  GET_ALL_VISIBLE_VERSIONS_QUERY = 'SELECT * FROM doc.versions_info WHERE ' + VERSION_VISIBLE_FIELD +
    ' ORDER BY ' + VERSION_DATE_FIELD + ' DESC';

type

  TBasedOnDBApplicationVersionInfoService = class(TAbstractApplicationService, IApplicationVersionInfoService)
    private
      FQueryExecutor: IQueryExecutor;
      FVersionPropertiesIniFile: TPropertiesIniFile;

      FLastServerVersion: string;
      FLastLaunchedVersion: string;

      function GetLastLaunchedVersion: string;
      function GetLastVersion: string;

      function CreateVersionInfoDtoFromDatareader(DataReader: IDataReader): TVersionInfoDTO;

    public

      destructor Destroy; override;
      constructor Create(QueryExecutor: IQueryExecutor; IniFile:TPropertiesIniFile);

      function GetLastVersionChanges: TVersionInfoDTOs;
      function GetAllVersionsChanges: TVersionInfoDTOs;
      procedure WriteLastVersionToFile;


  end;

implementation

{ TBasedOnDBApplicationVersionInfoService }

constructor TBasedOnDBApplicationVersionInfoService.Create(
  QueryExecutor: IQueryExecutor; IniFile: TPropertiesIniFile);
begin
  inherited Create;

  FVersionPropertiesIniFile := IniFile;
  FQueryExecutor := QueryExecutor;

  FLastServerVersion := GetLastVersion;  
  FLastLaunchedVersion := GetLastLaunchedVersion;

end;

function TBasedOnDBApplicationVersionInfoService.CreateVersionInfoDtoFromDatareader(
  DataReader: IDataReader): TVersionInfoDTO;
begin
  Result := TVersionInfoDTO.Create;

  Result.Id := DataReader[VERSION_ID_FIELD];
  Result.VersionNumber := DataReader[VERSION_NUMBER_FIELD];
  Result.Date := DataReader[VERSION_DATE_FIELD];
  Result.Description := DataReader[VERSION_DESCRIPTION_FIELD];
  Result.FilePath := DataReader[VERSION_FILE_PATH_FIELD];
  Result.Visible := DataReader[VERSION_VISIBLE_FIELD];

end;

destructor TBasedOnDBApplicationVersionInfoService.Destroy;
begin
  FreeAndNil(FQueryExecutor);
  inherited;
end;

function TBasedOnDBApplicationVersionInfoService.GetAllVersionsChanges: TVersionInfoDTOs;
var
  DataReader: IDataReader;
  DataSet: TDataSet;
begin
  Result := TVersionInfoDTOs.Create;

  DataReader :=
    FQueryExecutor.ExecuteSelectionQuery(GET_ALL_VISIBLE_VERSIONS_QUERY);

  while DataReader.Next do
  begin
    Result.Add(CreateVersionInfoDtoFromDatareader(DataReader));
  end;

end;

function TBasedOnDBApplicationVersionInfoService.GetLastLaunchedVersion: string;
begin
  FVersionPropertiesIniFile.GoToSection('AppVersion');
  Result := FVersionPropertiesIniFile.ReadValueForProperty('Version', varString, '');

end;

function TBasedOnDBApplicationVersionInfoService.GetLastVersion: string;
var
  DataReader: IDataReader;
  DataSet: TDataSet;
begin

  DataReader :=
    FQueryExecutor.ExecuteSelectionQuery(GET_ALL_VISIBLE_VERSIONS_QUERY);

  if DataReader.RecordCount <> 0 then
    Result := DataReader[VERSION_NUMBER_FIELD]
  else
    Result := '';

end;

function TBasedOnDBApplicationVersionInfoService.GetLastVersionChanges: TVersionInfoDTOs;
var
  DataReader: IDataReader;
  DataSet: TDataSet;
begin

  if FLastServerVersion <> FLastLaunchedVersion then
  begin

    Result := GetAllVersionsChanges;

  end
  else
    Result := nil;

end;

procedure TBasedOnDBApplicationVersionInfoService.WriteLastVersionToFile;
begin
  FVersionPropertiesIniFile.GoToSection('AppVersion');
  FVersionPropertiesIniFile.WriteValueForProperty('Version', FLastServerVersion);
end;

end.
