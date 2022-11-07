unit DocumentResponsiblePostgresRepository;

interface

uses

  IDocumentResponsibleRepositoryUnit,
  Employee,
  Department,
  SysUtils,
  Classes,
  QueryExecutor,
  DataReader;

type

  TDocumentResponsibleFieldNames = record

    IdFieldName: String;
    PersonnelNumberFieldName: String;
    NameFieldName: String;
    SurnameFieldName: String;
    PatronymicFieldName: String;
    TelephoneNumberFieldName: String;
    EmailFieldName: String;
    DepartmentIdFieldName: String;

  end;

  TDocumentResponsibleDepartmentFieldNames = record

    IdFieldName: String;
    CodeFieldName: String;
    ShortNameFieldName: String;
    FullNameFieldName: String;

  end;

  TDocumentResponsiblePostgresRepository =
    class (TInterfacedObject, IDocumentResponsibleRepository)

      private

        FQueryExecutor: IQueryExecutor;
        FDocumentResponsibleFieldNames: TDocumentResponsibleFieldNames;
        FDocumentResponsibleDepartmentFieldNames: TDocumentResponsibleDepartmentFieldNames;
        
      private

        procedure InitializeFieldNames;
        procedure InitializeDocumentResponsibleFieldNames;
        procedure InitializeDocumentResponsibleDepartmentFieldNames;

      private

        function IsDocumentResponsibleInfoExists(
          const ResponsibleId: Variant
        ): Boolean;

        procedure AddDocumentResponsible(
          DocumentResponsible: TEmployee
        );

        procedure ChangeDocumentResponsible(
          DocumentResponsible: TEmployee
        );

      private

        function CreateDocumentResponsibleFrom(
          DataReader: IDataReader;
          FieldNames: TDocumentResponsibleFieldNames
        ): TEmployee;

        function CreateDocumentResponsibleDepartmentFrom(
          DataReader: IDataReader;
          FieldNames: TDocumentResponsibleDepartmentFieldNames
        ): TDepartment;

      public

        constructor Create(QueryExecutor: IQueryExecutor);

        function FindDocumentResponsibleById(
          const ResponsibleId: Variant
        ): TEmployee;

        function FindDocumentResponsibleDepartmentById(
          const DepartmentId: Variant
        ): TDepartment;

        procedure UpdateDocumentResponsible(Responsible: TEmployee);

        property QueryExecutor: IQueryExecutor
        read FQueryExecutor write FQueryExecutor;

    end;

implementation

uses

  Variants;

{ TDocumentResponsiblePostgresRepository }


constructor TDocumentResponsiblePostgresRepository.Create(
  QueryExecutor: IQueryExecutor
);
begin

  inherited Create;

  Self.QueryExecutor := QueryExecutor;

  InitializeFieldNames;

end;

function TDocumentResponsiblePostgresRepository.
  FindDocumentResponsibleById(
    const ResponsibleId: Variant
  ): TEmployee;
var
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(
      'p' + FDocumentResponsibleFieldNames.IdFieldName, ResponsibleId
    );

    DataReader :=
      FQueryExecutor.ExecuteSelectionQuery(
        Format(
          'select ' +
          'a.%s, ' +
          'a.%s, ' +
          'initcap(a.%s) as %s, ' +
          'initcap(a.%s) as %s, ' +
          'initcap(a.%s) as %s, ' +
          'b.%s, ' +
          'a.%s, ' +
          'pe.%s ' +
          'from exchange.spr_person a ' +
          'left join exchange.spr_person_telephone_numbers b on a.%s = b.person_id ' +
          'left join exchange.person_email pe on pe.person_id = a.%s ' +
          'join nsi.spr_podr c on c.id = a.%s ' +
          'where a.%s=:p%s',
          [
            FDocumentResponsibleFieldNames.IdFieldName,
            FDocumentResponsibleFieldNames.PersonnelNumberFieldName,
            FDocumentResponsibleFieldNames.NameFieldName,
            FDocumentResponsibleFieldNames.NameFieldName,
            FDocumentResponsibleFieldNames.SurnameFieldName,
            FDocumentResponsibleFieldNames.SurnameFieldName,
            FDocumentResponsibleFieldNames.PatronymicFieldName,
            FDocumentResponsibleFieldNames.PatronymicFieldName,
            FDocumentResponsibleFieldNames.TelephoneNumberFieldName,
            FDocumentResponsibleFieldNames.DepartmentIdFieldName,
            FDocumentResponsibleFieldNames.EmailFieldName,

            FDocumentResponsibleFieldNames.IdFieldName,

            FDocumentResponsibleFieldNames.IdFieldName,

            FDocumentResponsibleFieldNames.DepartmentIdFieldName,

            FDocumentResponsibleFieldNames.IdFieldName,
            FDocumentResponsibleFieldNames.IdFieldName
          ]
        ),
        QueryParams
      );

    if DataReader.RecordCount = 0 then begin

      raise Exception.Create(
              'Для документа не найдено ' +
              'ответственное лицо'
            );

    end;

    Result := CreateDocumentResponsibleFrom(DataReader, FDocumentResponsibleFieldNames);

  finally

    FreeAndNil(QueryParams);

  end;

end;

function TDocumentResponsiblePostgresRepository.
  FindDocumentResponsibleDepartmentById(
    const DepartmentId: Variant
  ): TDepartment;
var
    DataReader: IDataReader;
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(
      'p' + FDocumentResponsibleDepartmentFieldNames.IdFieldName, DepartmentId
    );

    DataReader :=
      FQueryExecutor.ExecuteSelectionQuery(
        Format(
          'SELECT ' +
          '%s,' +
          '%s,' +
          '%s,' +
          'initcap(%s) as %s ' +
          'FROM nsi.spr_podr ' +
          'WHERE %s=:p%s',
          [
            FDocumentResponsibleDepartmentFieldNames.IdFieldName,
            FDocumentResponsibleDepartmentFieldNames.CodeFieldName,
            FDocumentResponsibleDepartmentFieldNames.ShortNameFieldName,
            FDocumentResponsibleDepartmentFieldNames.FullNameFieldName,
            FDocumentResponsibleDepartmentFieldNames.FullNameFieldName,

            FDocumentResponsibleDepartmentFieldNames.IdFieldName,
            FDocumentResponsibleDepartmentFieldNames.IdFieldName
          ]
        ),
        QueryParams
      );

    if DataReader.RecordCount = 0 then begin

      raise Exception.Create(
        'Для ответственного за документ лица ' +
        'не найдена информация о подразделении'
      );

    end;

    Result := CreateDocumentResponsibleDepartmentFrom(DataReader, FDocumentResponsibleDepartmentFieldNames);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TDocumentResponsiblePostgresRepository.
  CreateDocumentResponsibleDepartmentFrom(
    DataReader: IDataReader;
    FieldNames: TDocumentResponsibleDepartmentFieldNames
  ): TDepartment;
begin

  with FieldNames do begin

    Result := TDepartment.Create(DataReader[IdFieldName]);

    Result.Code := DataReader[CodeFieldName];
    Result.ShortName := DataReader[ShortNameFieldName];
    Result.FullName := DataReader[FullNameFieldName];

  end;

end;

function TDocumentResponsiblePostgresRepository.
  CreateDocumentResponsibleFrom(
    DataReader: IDataReader;
    FieldNames: TDocumentResponsibleFieldNames
  ): TEmployee;
begin

  with FieldNames do begin

    Result := TEmployee.Create(DataReader[IdFieldName]);

    Result.PersonnelNumber := DataReader[PersonnelNumberFieldName];
    Result.Name := DataReader[NameFieldName];
    Result.Surname := DataReader[SurnameFieldName];
    Result.Patronymic := DataReader[PatronymicFieldName];

    if not VarIsNull(DataReader[TelephoneNumberFieldName]) then
      Result.TelephoneNumber := DataReader[TelephoneNumberFieldName];

    Result.DepartmentIdentity := DataReader[DepartmentIdFieldName];

    if not VarIsNull(DataReader[EmailFieldName]) then
      Result.Email := DataReader[EmailFieldName];

  end;

end;


procedure TDocumentResponsiblePostgresRepository.UpdateDocumentResponsible(
  Responsible: TEmployee);
begin

  if not IsDocumentResponsibleInfoExists(Responsible.Identity) then
    AddDocumentResponsible(Responsible)

  else ChangeDocumentResponsible(Responsible);

end;

procedure TDocumentResponsiblePostgresRepository.AddDocumentResponsible(
  DocumentResponsible: TEmployee
);
var
    RowsAffected: Integer;
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently('pid', DocumentResponsible.Identity)
      .AddFluently('ptn', DocumentResponsible.TelephoneNumber);

    RowsAffected :=
      FQueryExecutor.ExecuteModificationQuery(
        'INSERT INTO exchange.spr_person_telephone_numbers ' +
        '(person_id, telephone_number) VALUES (:pid,:ptn)',
        QueryParams
      );

    if RowsAffected = 0 then begin

      raise Exception.Create(
        'Информация об ответственном за документ ' +
        'не была добавлена в базу данных по неизвестной ' +
        'причине'
      );

    end;
  
  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TDocumentResponsiblePostgresRepository.ChangeDocumentResponsible(
  DocumentResponsible: TEmployee
);
var
    RowsAffected: Integer;
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently('pid', DocumentResponsible.Identity)
      .AddFluently('ptn', DocumentResponsible.TelephoneNumber);

    RowsAffected :=
      FQueryExecutor.ExecuteModificationQuery(
        'UPDATE exchange.spr_person_telephone_numbers ' +
        'SET telephone_number=:ptn WHERE person_id=:pid',
        QueryParams
      );

   if RowsAffected = 0 then begin

    raise Exception.Create(
      'Информация об ответственном за документ ' +
      'не была изменена по неизвестной причине'
    );

   end;

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

procedure TDocumentResponsiblePostgresRepository.InitializeDocumentResponsibleDepartmentFieldNames;
begin

  FDocumentResponsibleDepartmentFieldNames.IdFieldName := 'id';
  FDocumentResponsibleDepartmentFieldNames.CodeFieldName := 'podr_code';
  FDocumentResponsibleDepartmentFieldNames.ShortNameFieldName := 'podr_short_name';
  FDocumentResponsibleDepartmentFieldNames.FullNameFieldName := 'podr_name';
  
end;

procedure TDocumentResponsiblePostgresRepository.InitializeDocumentResponsibleFieldNames;
begin

  FDocumentResponsibleFieldNames.IdFieldName := 'id';
  FDocumentResponsibleFieldNames.PersonnelNumberFieldName := 'tab_nbr';
  FDocumentResponsibleFieldNames.NameFieldName := 'name';
  FDocumentResponsibleFieldNames.SurnameFieldName := 'family';
  FDocumentResponsibleFieldNames.PatronymicFieldName := 'patronymic';
  FDocumentResponsibleFieldNames.TelephoneNumberFieldName := 'telephone_number';
  FDocumentResponsibleFieldNames.EmailFieldName := 'email';
  FDocumentResponsibleFieldNames.DepartmentIdFieldName := 'podr_id';
  
end;

procedure TDocumentResponsiblePostgresRepository.InitializeFieldNames;
begin

  InitializeDocumentResponsibleFieldNames;
  InitializeDocumentResponsibleDepartmentFieldNames;
  
end;

function TDocumentResponsiblePostgresRepository.IsDocumentResponsibleInfoExists(
  const ResponsibleId: Variant
): Boolean;
var
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add('pid', ResponsibleId);

    DataReader :=
      FQueryExecutor.ExecuteSelectionQuery(
        'SELECT 1 as result FROM exchange.spr_person_telephone_numbers WHERE ' +
        'person_id=:pid',
        QueryParams
      );

    Result := not VarIsNull(DataReader['result']);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

end.
