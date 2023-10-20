unit ServiceNoteCardFrameFactory;

interface

uses

  DocumentCardFrameFactory,
  DocumentChargesFormViewModelUnit,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentChargeSheetsFormViewModel,
  unDocumentChargesFrame,
  unDocumentChargeSheetsFrame,
  unServiceNoteChargesFrame,
  unServiceNoteChargeSheetsFrame,
  unDocumentCardFrame,
  unServiceNoteCardFrame,
  SysUtils;

type

  TServiceNoteCardFrameFactory = class (TDocumentCardFrameFactory)

    protected

      function CreateDefaultDocumentCardFrameInstance(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentCardFrame; override;

    protected

      function CreateDocumentChargesFrameInstance: TDocumentChargesFrame; override;
      function CreateDocumentChargeSheetsFrameInstance: TDocumentChargeSheetsFrame; override;

  end;

implementation

{ TServiceNoteCardFrameFactory }

function TServiceNoteCardFrameFactory.CreateDefaultDocumentCardFrameInstance(
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO): TDocumentCardFrame;
begin

  Result := TServiceNoteCardFrame.Create(nil, False, False);
  
end;


function TServiceNoteCardFrameFactory.CreateDocumentChargesFrameInstance: TDocumentChargesFrame;
begin

  Result := TServiceNoteChargesFrame.Create(nil, False, False);

end;

function TServiceNoteCardFrameFactory.CreateDocumentChargeSheetsFrameInstance: TDocumentChargeSheetsFrame;
begin

  Result := TServiceNoteChargeSheetsFrame.Create(nil, False, False);
  
end;

end.
