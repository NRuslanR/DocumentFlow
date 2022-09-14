unit DocumentRelationsFormViewModelMapper;

interface

uses

  DB,
  DocumentFullInfoDTO,
  DocumentRelationSetHolder,
  DocumentRelationsFormViewModelUnit,
  SysUtils,
  Classes;

type

  TDocumentRelationsFormViewModelMapper = class

    protected

      function CreateDocumentRelationsFormViewModelInstance:
        TDocumentRelationsFormViewModel; virtual;
        
    public

      function MapDocumentRelationsFormViewModelFrom(
        DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO;
        DocumentRelationsSetHolder: TDocumentRelationSetHolder
      ): TDocumentRelationsFormViewModel; virtual;

      function MapDocumentRelationsFormViewModelTo(
        DocumentRelationsFormViewModel: TDocumentRelationsFormViewModel
      ): TDocumentRelationsInfoDTO; virtual;

      function CreateEmptyDocumentRelationsFormViewModel(
        DocumentRelationsSetHolder: TDocumentRelationSetHolder
      ): TDocumentRelationsFormViewModel; virtual;


  end;
  
implementation

{ TDocumentRelationsFormViewModelMapper }

function TDocumentRelationsFormViewModelMapper.
  CreateDocumentRelationsFormViewModelInstance: TDocumentRelationsFormViewModel;
begin

  Result := TDocumentRelationsFormViewModel.Create;
  
end;

function TDocumentRelationsFormViewModelMapper.
  CreateEmptyDocumentRelationsFormViewModel(
    DocumentRelationsSetHolder: TDocumentRelationSetHolder
  ): TDocumentRelationsFormViewModel;
begin

  Result := CreateDocumentRelationsFormViewModelInstance;

  Result.DocumentRelationSetHolder :=
    DocumentRelationsSetHolder;
    
end;

function TDocumentRelationsFormViewModelMapper.
  MapDocumentRelationsFormViewModelFrom(
    DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO;
    DocumentRelationsSetHolder: TDocumentRelationSetHolder
  ): TDocumentRelationsFormViewModel;
var
  DocumentRelationInfoDTO: TDocumentRelationInfoDTO;
begin

  Result := CreateDocumentRelationsFormViewModelInstance;

  if Assigned(DocumentRelationsInfoDTO) then begin


    for DocumentRelationInfoDTO in DocumentRelationsInfoDTO do begin

      with DocumentRelationsSetHolder do begin

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

  Result.DocumentRelationSetHolder := DocumentRelationsSetHolder;

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

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

end.

