unit DocumentApprovingListSetHolderMapper;

interface

uses

  DocumentApprovingListDTO,
  DocumentApprovingListSetHolder,
  DocumentApprovingListRecordSetHolder,
  DocumentApprovingListSetHolderFactory,
  DocumentDataSetHoldersFactory,
  UIDocumentKinds,
  SysUtils,
  Classes;

type

  TDocumentApprovingListSetHolderMapper = class

    protected

      FDocumentApprovingListSetHolderFactory: IDocumentApprovingListSetHolderFactory;

    protected

      procedure FillDocumentApprovingListSetHolderFrom(
        DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;
        DocumentApprovingListDTOs: TDocumentApprovingListDTOs
      );

      procedure FillDocumentApprovingListRecordSetHolderFrom(
        DocumentApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;
        DocumentApprovingListDto: TDocumentApprovingListDTO;
        DocumentApprovingListRecordDtos: TDocumentApprovingListRecordDTOs
      );

    public

      constructor Create(
        DocumentApprovingListSetHolderFactory: IDocumentApprovingListSetHolderFactory
      );

      function MapDocumentApprovingListSetHolderFrom(
        DocumentApprovingListDTOs: TDocumentApprovingListDTOs
      ): TDocumentApprovingListSetHolder;
      
  end;
  
implementation

uses

  StrUtils,
  AbstractDataSetHolder;

{ TDocumentApprovingListSetHolderMapper }

constructor TDocumentApprovingListSetHolderMapper.Create(
  DocumentApprovingListSetHolderFactory: IDocumentApprovingListSetHolderFactory
);
begin

  inherited Create;

  FDocumentApprovingListSetHolderFactory := DocumentApprovingListSetHolderFactory;
  
end;

function TDocumentApprovingListSetHolderMapper.MapDocumentApprovingListSetHolderFrom(
  DocumentApprovingListDTOs: TDocumentApprovingListDTOs
): TDocumentApprovingListSetHolder;
begin

  Result := FDocumentApprovingListSetHolderFactory.CreateDocumentApprovingListSetHolder;
  
  FillDocumentApprovingListSetHolderFrom(Result, DocumentApprovingListDTOs);
  
end;

procedure TDocumentApprovingListSetHolderMapper.FillDocumentApprovingListSetHolderFrom(
  DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;
  DocumentApprovingListDTOs: TDocumentApprovingListDTOs
);
var
    DocumentApprovingListDto: TDocumentApprovingListDTO;
begin

  for DocumentApprovingListDto in DocumentApprovingListDTOs do begin

    with DocumentApprovingListSetHolder, DocumentApprovingListDto do begin

      Append;

      TitleFieldValue := Title;

      Post;

      FillDocumentApprovingListRecordSetHolderFrom(
        ApprovingListRecordSetHolder, DocumentApprovingListDto, Records
      );
      
    end;
    
  end;

  DocumentApprovingListSetHolder.First;
  DocumentApprovingListSetHolder.ApprovingListRecordSetHolder.First;

end;

procedure TDocumentApprovingListSetHolderMapper.FillDocumentApprovingListRecordSetHolderFrom(
  DocumentApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;
  DocumentApprovingListDto: TDocumentApprovingListDTO;
  DocumentApprovingListRecordDtos: TDocumentApprovingListRecordDTOs
);
var
    DocumentApprovingListRecordDto: TDocumentApprovingListRecordDTO;
begin

  for DocumentApprovingListRecordDto in DocumentApprovingListRecordDtos
  do begin

    with DocumentApprovingListRecordSetHolder, DocumentApprovingListRecordDto
    do begin

      Append;

      ListTitleFieldValue := DocumentApprovingListDto.Title;
      ApproverNameFieldValue := ApproverDTO.FullName;
      ApproverSpecialityFieldValue := ApproverDTO.Speciality;

      case ApprovingPerformingResultDTO of

        DocumentApproved:

          ApprovingPerformingResultFieldValue :=
            IfThen(
              DocumentApprovingListDto.Kind = alkApproving,
              'Согласовано в СЭД',
              IfThen(
                DocumentApprovingListDto.Kind = alkViseing,
                ' в СЭД',
                ''
              )
            );

        DocumentNotApproved:

          ApprovingPerformingResultFieldValue :=
            IfThen(
              DocumentApprovingListDto.Kind = alkApproving,
              'Не согласовано  в СЭД',
              IfThen(
                DocumentApprovingListDto.Kind = alkViseing,
                '',
                ''
              )
            );

        DocumentApprovingNotPerformed:

          ApprovingPerformingResultFieldValue :=
            IfThen(
              DocumentApprovingListDto.Kind = alkApproving,
              'На согласовании',
              IfThen(
                DocumentApprovingListDto.Kind = alkViseing,
                '',
                ''
              )
            );

      end;

      Post;

    end;

  end;
    
end;

end.
