unit DocumentChargeSheetsChangesInfoDTOMapperFactory;

interface

uses

  DocumentChargeSheetsChangesInfoDTOMapper,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetsChangesInfoDTOMapperFactory = class

    public

      function CreateDocumentChargeSheetsChangesInfoDTOMapper:
        TDocumentChargeSheetsChangesInfoDTOMapper; virtual;
      
  end;
implementation

{ TDocumentChargeSheetsChangesInfoDTOMapperFactory }

function TDocumentChargeSheetsChangesInfoDTOMapperFactory.
  CreateDocumentChargeSheetsChangesInfoDTOMapper:
    TDocumentChargeSheetsChangesInfoDTOMapper;
begin

  Result := TDocumentChargeSheetsChangesInfoDTOMapper.Create;

end;

end.
