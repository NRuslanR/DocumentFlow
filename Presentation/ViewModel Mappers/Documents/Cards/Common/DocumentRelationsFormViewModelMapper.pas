unit DocumentRelationsFormViewModelMapper;

interface

uses

  DB,
  DocumentFullInfoDTO,
  DocumentRelationSetHolder,
  DocumentRelationsFormViewModelUnit,
  DocumentRelationSetHolderFactory,
  SysUtils,
  Classes;

type

  TDocumentRelationsFormViewModelMapper = class

    protected

      FDocumentRelationSetHolderFactory: IDocumentRelationSetHolderFactory;

      function CreateDocumentRelationsFormViewModelInstance:
        TDocumentRelationsFormViewModel; virtual;
        
    public

      constructor Create(DocumentRelationSetHolderFactory: IDocumentRelationSetHolderFactory);
      
      function MapDocumentRelationsFormViewModelFrom(
        DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO
      ): TDocumentRelationsFormViewModel; virtual;

      function MapDocumentRelationsFormViewModelTo(
        DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel
      ): TDocumentRelationsInfoDTO; virtual;

      function CreateEmptyDocumentRelationsFormViewModel: TDocumentRelationsFormViewModel; virtual;


  end;
  
implementation

{ TDocumentRelationsFormViewModelMapper }

constructor TDocumentRelationsFormViewModelMapper.Create(
  DocumentRelationSetHolderFactory: IDocumentRelationSetHolderFactory);
begin

  inherited Create;

  FDocumentRelationSetHolderFactory := DocumentRelationSetHolderFactory;
  
end;

function TDocumentRelationsFormViewModelMapper.
  CreateDocumentRelationsFormViewModelInstance: TDocumentRelationsFormViewModel;
begin

  Result := TDocumentRelationsFormViewModel.Create;
  
end;

function TDocumentRelationsFormViewModelMapper.
  CreateEmptyDocumentRelationsFormViewModel: TDocumentRelationsFormViewModel;
begin

  Result := CreateDocumentRelationsFormViewModelInstance;
  
  Result.DocumentRelationSetHolder :=
    FDocumentRelationSetHolderFactory.CreateDocumentRelationSetHolder;

end;

function TDocumentRelationsFormViewModelMapper.
  MapDocumentRelationsFormViewModelFrom(
    DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO
  ): TDocumentRelationsFormViewModel;
var
  DocumentRelationInfoDTO: TDocumentRelationInfoDTO;
begin

  Result := CreateEmptyDocumentRelationsFormViewModel;

  if not Assigned(DocumentRelationsInfoDTO) then Exit;

  for DocumentRelationInfoDTO in DocumentRelationsInfoDTO do begin

    with Result.DocumentRelationSetHolder do begin

      Append;

      DocumentIdFieldValue := DocumentRelationInfoDTO.RelatedDocumentId;
      DocumentNumberFieldValue := DocumentRelationInfoDTO.RelatedDocumentNumber;
      DocumentDateFieldValue := DocumentRelationInfoDTO.RelatedDocumentDate;
      DocumentNameFieldValue := DocumentRelationInfoDTO.RelatedDocumentName;
      DocumentKindIdFieldValue := DocumentRelationInfoDTO.RelatedDocumentKindId;
      DocumentKindNameFieldValue := DocumentRelationInfoDTO.RelatedDocumentKindName;

      Post;

    end;

  end;

end;

function TDocumentRelationsFormViewModelMapper.
  MapDocumentRelationsFormViewModelTo(
    DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel
  ): TDocumentRelationsInfoDTO;
var DocumentRelationsSetHolder: TDocumentRelationSetHolder;
    DocumentRelationInfoDTO: TDocumentRelationInfoDTO;
begin

  DocumentRelationsSetHolder :=
    DocumentRelationsFormViewModel.DocumentRelationSetHolder;
    
  Result := TDocumentRelationsInfoDTO.Create;
  
  try

    with DocumentRelationsSetHolder do begin

      First;

      while not Eof do begin

        DocumentRelationInfoDTO := TDocumentRelationInfoDTO.Create;

        Result.Add(DocumentRelationInfoDTO);

        DocumentRelationInfoDTO.RelatedDocumentId := DocumentIdFieldValue;

        DocumentRelationInfoDTO.RelatedDocumentKindId := DocumentKindIdFieldValue;

        DocumentRelationInfoDTO.RelatedDocumentKindName := DocumentKindNameFieldValue;

        DocumentRelationInfoDTO.RelatedDocumentNumber := DocumentNumberFieldValue;

        DocumentRelationInfoDTO.RelatedDocumentName := DocumentNameFieldValue;

        DocumentRelationInfoDTO.RelatedDocumentDate := DocumentDateFieldValue;

        Next;
      
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.

