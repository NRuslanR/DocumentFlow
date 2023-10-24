{ Refactor }
unit DocumentRelationsUnit;

interface

uses

  Document,
  DomainObjectValueUnit,
  DomainObjectUnit,
  VariantListUnit,
  SysUtils,
  Classes,
  Variants;

type

  TDocumentRelations = class (TDomainObjectValue)

    private

      FTargetDocumentId: Variant;
      FRelationInfoList: TVariantList;

      function GetRelationCount: Integer;
      
    public

      destructor Destroy; override;
      constructor Create; overload;
      constructor Create(const TargetDocumentId: Variant); overload;

      procedure AddRelation(
        const RelatedDocumentId: Variant;
        const RelatedDocumentTypeId: Variant
      );

      procedure AssignTargetDocument(Document: TDocument);

      function ContainsRelation(
        const RelatedDocumentId: Variant;
        const RelatedDocumentTypeId: Variant
      ): Boolean;
      
    published

      property TargetDocumentId: Variant
      read FTargetDocumentId write FTargetDocumentId;

      property RelatedDocumentInfoList: TVariantList
      read FRelationInfoList;

      property RelationCount: Integer
      read GetRelationCount;
      
  end;

implementation

{ TDocumentRelations }

procedure TDocumentRelations.AddRelation(
  const RelatedDocumentId: Variant;
  const RelatedDocumentTypeId: Variant
);
begin

  FRelationInfoList.Add(
    VarArrayOf([RelatedDocumentId, RelatedDocumentTypeId])
  );

end;

procedure TDocumentRelations.AssignTargetDocument(Document: TDocument);
begin

  TargetDocumentId := Document.Identity;

end;

function TDocumentRelations.ContainsRelation(const RelatedDocumentId,
  RelatedDocumentTypeId: Variant): Boolean;
var Relation: Variant;
begin

  for Relation in FRelationInfoList do begin

    if (Relation[0] = RelatedDocumentId) and
       (Relation[1] = RelatedDocumentTypeId)
    then begin

      Result := True;
      Exit;

    end;

  end;

  Result := False;

end;

constructor TDocumentRelations.Create(const TargetDocumentId: Variant);
begin

  inherited Create;

  FRelationInfoList := TVariantList.Create;
  FTargetDocumentId := TargetDocumentId;
  
end;

constructor TDocumentRelations.Create;
begin

  inherited;

  FRelationInfoList := TVariantList.Create;
  
end;

destructor TDocumentRelations.Destroy;
begin

  FreeAndNil(FRelationInfoList);
  inherited;

end;

function TDocumentRelations.GetRelationCount: Integer;
begin

  Result := FRelationInfoList.Count;
  
end;

end.
