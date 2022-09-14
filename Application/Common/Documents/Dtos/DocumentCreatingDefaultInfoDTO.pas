unit DocumentCreatingDefaultInfoDTO;

interface

uses

  EmployeeInfoDTO,
  DocumentResponsibleInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  SysUtils,
  Classes;
  
type

  TDocumentCreatingDefaultInfoDTO = class

    public

      DocumentKindId: Variant; { refactor: depreacted }
      DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO;
      DocumentSignerInfoDTO: TDocumentFlowEmployeeInfoDTO;

      destructor Destroy; override;

  end;
  
implementation

{ TDocumentCreatingDefaultInfoDTO }

destructor TDocumentCreatingDefaultInfoDTO.Destroy;
begin

  FreeAndNil(DocumentResponsibleInfoDTO);
  FreeAndNil(DocumentSignerInfoDTO);
  
  inherited;

end;

end.
