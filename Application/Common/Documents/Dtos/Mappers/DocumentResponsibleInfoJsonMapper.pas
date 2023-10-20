unit DocumentResponsibleInfoJsonMapper;

interface

uses

  DocumentResponsibleInfoDTO,
  DepartmentInfoDTO,
  uLkJSON,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDocumentResponsibleInfoJsonMapper = interface (IGetSelf)

    function MapDocumentResponsibleInfoJsonObject(
      const DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
    ): TlkJSONobject;

    function MapDocumentResponsibleInfoJson(
      const DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
    ): String;

  end;

  TDocumentResponsibleInfoJsonMapper =
    class (TInterfacedObject, IDocumentResponsibleInfoJsonMapper)

      private

        function MapDepartmentInfoJsonObject(
          const DepartmentInfoDTO: TDepartmentInfoDTO
        ): TlkJSONobject;
        
      public

        function GetSelf: TObject;

        function MapDocumentResponsibleInfoJsonObject(
          const DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
        ): TlkJSONobject;

        function MapDocumentResponsibleInfoJson(
          const DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
        ): String;

    end;

implementation

uses

  Variants;

{ TDocumentResponsibleInfoJsonMapper }

function TDocumentResponsibleInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentResponsibleInfoJsonMapper.MapDocumentResponsibleInfoJson(
  const DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO): String;
var
    ResponsibleInfoJsonObject: TlkJSONobject;
begin

  ResponsibleInfoJsonObject :=
    MapDocumentResponsibleInfoJsonObject(DocumentResponsibleInfoDTO);

  try

    Result := TlkJSON.GenerateText(ResponsibleInfoJsonObject);
    
  finally

    FreeAndNil(ResponsibleInfoJsonObject);

  end;

end;

function TDocumentResponsibleInfoJsonMapper.MapDocumentResponsibleInfoJsonObject(
  const DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with DocumentResponsibleInfoDTO, Result do begin

      Add('Id', VarToStr(Id));
      Add('Name', Name);
      Add('TelephoneNumber', TelephoneNumber);

      Add('DepartmentInfoDTO', MapDepartmentInfoJsonObject(DepartmentInfoDTO));
      
    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

function TDocumentResponsibleInfoJsonMapper.MapDepartmentInfoJsonObject(
  const DepartmentInfoDTO: TDepartmentInfoDTO): TlkJSONobject;
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
