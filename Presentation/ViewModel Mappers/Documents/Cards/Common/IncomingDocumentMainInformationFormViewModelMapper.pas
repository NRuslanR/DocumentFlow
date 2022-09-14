unit IncomingDocumentMainInformationFormViewModelMapper;

interface

uses

  DocumentFullInfoDTO,
  IncomingDocumentFullInfoDTO,
  IncomingDocumentMainInformationFormViewModel,
  DocumentMainInformationFormViewModelMapper,
  DocumentMainInformationFormViewModelUnit,
  SysUtils,
  Classes;

type

  TIncomingDocumentMainInformationFormViewModelMapper =
    class (TDocumentMainInformationFormViewModelMapper)

      protected

        FOriginalDocumentMainInformationFormViewModelMapper:
          TDocumentMainInformationFormViewModelMapper;
          
      public

        destructor Destroy; override;
        constructor Create(
          DocumentMainInformationFormViewModelMapper:
            TDocumentMainInformationFormViewModelMapper
        );
        
        function MapDocumentMainInformationFormViewModelFrom(
          DocumentDTO: TDocumentDTO
        ): TDocumentMainInformationFormViewModel; override;

        property OriginalDocumentMainInformationFormViewModelMapper:
          TDocumentMainInformationFormViewModelMapper
        read FOriginalDocumentMainInformationFormViewModelMapper
        write FOriginalDocumentMainInformationFormViewModelMapper;
        
    end;
  
implementation

{ TIncomingDocumentMainInformationFormViewModelMapper }

constructor TIncomingDocumentMainInformationFormViewModelMapper.Create(
  DocumentMainInformationFormViewModelMapper:
    TDocumentMainInformationFormViewModelMapper
);
begin

  inherited Create;

  FOriginalDocumentMainInformationFormViewModelMapper :=
    DocumentMainInformationFormViewModelMapper;
    
end;

destructor TIncomingDocumentMainInformationFormViewModelMapper.Destroy;
begin

  FreeAndNil(FOriginalDocumentMainInformationFormViewModelMapper);
  inherited;

end;

function TIncomingDocumentMainInformationFormViewModelMapper.
  MapDocumentMainInformationFormViewModelFrom(
    DocumentDTO: TDocumentDTO
  ): TDocumentMainInformationFormViewModel;
var IncomingDocumentDTO: TIncomingDocumentDTO;

    IncomingDocumentMainInformationFormViewModel:
      TIncomingDocumentMainInformationFormViewModel;

    OriginalDocumentMainInformationFormViewModel:
      TDocumentMainInformationFormViewModel;
begin

  IncomingDocumentDTO := DocumentDTO as TIncomingDocumentDTO;

  OriginalDocumentMainInformationFormViewModel :=

    FOriginalDocumentMainInformationFormViewModelMapper.
      MapDocumentMainInformationFormViewModelFrom(
        IncomingDocumentDTO.OriginalDocumentDTO
      );

  IncomingDocumentMainInformationFormViewModel :=
    TIncomingDocumentMainInformationFormViewModel.Create(
      OriginalDocumentMainInformationFormViewModel
    );

  { refactor: получать из dto prefix, main value }
  
  IncomingDocumentMainInformationFormViewModel.IncomingNumberPartsSeparator :=
    IncomingDocumentDTO.IncomingNumberPartsSeparator;

  IncomingDocumentMainInformationFormViewModel.IncomingNumber :=
    IncomingDocumentDTO.IncomingNumber;

  IncomingDocumentMainInformationFormViewModel.ReceiptDate :=
    IncomingDocumentDTO.ReceiptDate;

  IncomingDocumentMainInformationFormViewModel.DocumentId :=
    IncomingDocumentDTO.Id;

  IncomingDocumentMainInformationFormViewModel.BaseDocumentId :=
    OriginalDocumentMainInformationFormViewModel.DocumentId;

  IncomingDocumentMainInformationFormViewModel.Kind :=
    IncomingDocumentDTO.Kind;

  IncomingDocumentMainInformationFormViewModel.KindId :=
    IncomingDocumentDTO.KindId;

  IncomingDocumentMainInformationFormViewModel.CurrentWorkCycleStageNumber :=
    IncomingDocumentDTO.CurrentWorkCycleStageNumber;

  IncomingDocumentMainInformationFormViewModel.CurrentWorkCycleStageName :=
    IncomingDocumentDTO.CurrentWorkCycleStageName;

  Result := IncomingDocumentMainInformationFormViewModel;

end;

end.
