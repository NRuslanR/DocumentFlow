unit DocumentChargeSheetsChangesInfoDTO;

interface

uses

  DocumentChargeSheetsInfoDTO,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetsChangesInfoDTO = class

    AddedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
    ChangedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
    RemovedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;

    destructor Destroy; override;

  end;

implementation

{ TDocumentChargeSheetsChangesInfoDTO }

destructor TDocumentChargeSheetsChangesInfoDTO.Destroy;
begin

  FreeAndNil(AddedDocumentChargeSheetsInfoDTO);
  FreeAndNil(ChangedDocumentChargeSheetsInfoDTO);
  FreeAndNil(RemovedDocumentChargeSheetsInfoDTO);
  
  inherited;

end;

end.
