unit DocumentFlowEmployeeInfoJsonMapper;

interface

uses

  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  uLkJSON,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDocumentFlowEmployeeInfoJsonMapper = interface (IGetSelf)

    function MapDocumentFlowEmployeeInfoJsonObject(const DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO): TlkJSONObject;
    function MapDocumentFlowEmployeeInfoJson(const DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO): String;

  end;

  TDocumentFlowEmployeeInfoJsonMapper =
    class (TInterfacedObject, IDocumentFlowEmployeeInfoJsonMapper)

      private

        function GetDepartmentInfoJsonObject(
          const DepartmentInfoDTO: TDepartmentInfoDTO
        ): TlkJSONObject;

      public

        function GetSelf: TObject;

        function MapDocumentFlowEmployeeInfoJsonObject(const DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO): TlkJSONObject;
        function MapDocumentFlowEmployeeInfoJson(const DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO): String;

    end;

implementation

uses

  Variants;
  
{ TDocumentFlowEmployeeInfoJsonMapper }

function TDocumentFlowEmployeeInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;

end;

function TDocumentFlowEmployeeInfoJsonMapper.MapDocumentFlowEmployeeInfoJson(
  const DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO): String;
var
    EmployeeJsonObject: TlkJSONobject;
begin

  EmployeeJsonObject := MapDocumentFlowEmployeeInfoJsonObject(DocumentFlowEmployeeInfoDTO);

  try

    Result := TlkJSON.GenerateText(EmployeeJsonObject);

  finally

    FreeAndNil(EmployeeJsonObject);

  end;

end;

function TDocumentFlowEmployeeInfoJsonMapper.MapDocumentFlowEmployeeInfoJsonObject(
  const DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO): TlkJSONObject;
begin

  Result := TlkJSONobject.Create;

  try

    with DocumentFlowEmployeeInfoDTO, Result do begin

      Add('Id', VarToStr(Id));
      Add('LeaderId', VarToStr(LeaderId));
      Add('PersonnelNumber', PersonnelNumber);
      Add('Name', Name);
      Add('Surname', Surname);
      Add('Patronymic', Patronymic);
      Add('FullName', FullName);
      Add('Speciality', Speciality);
      Add('RoleId', VarToStr(RoleId));
      Add('IsForeign', IsForeign);
      Add('DepartmentInfoDTO', GetDepartmentInfoJsonObject(DepartmentInfoDTO));

    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

function TDocumentFlowEmployeeInfoJsonMapper.GetDepartmentInfoJsonObject(
  const DepartmentInfoDTO: TDepartmentInfoDTO): TlkJSONObject;
begin

  Result := TlkJSONobject.Create;

  try

    with DepartmentInfoDTO, Result do begin

      Add('Id', VarToStr(Id));
      Add('Code', Code);
      Add('Name', Name);
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
