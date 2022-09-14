unit RespondingDocumentCreatingAppService;

interface

uses

  DocumentFullInfoDTO,
  ApplicationService,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  SysUtils;

type

  TRespondingDocumentCreatingResultDto = class

    public

      DocumentFullInfoDTO: TDocumentFullInfoDTO;
      DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;

      destructor Destroy; override;
      
  end;

  IRespondingDocumentCreatingAppService = interface (IApplicationService)

    function CreateRespondingDocumentFor(
      const DocumentId, EmployeeId: Variant
    ): TRespondingDocumentCreatingResultDto;
    
  end;

implementation

{ TRespondingDocumentCreatingResultDto }

destructor TRespondingDocumentCreatingResultDto.Destroy;
begin

  FreeAndNil(DocumentFullInfoDTO);
  FreeAndNil(DocumentUsageEmployeeAccessRightsInfoDTO);
  
  inherited;

end;

end.
