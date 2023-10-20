unit DocumentKindsPanelController;

interface

uses

  UIDocumentKinds,
  EmployeeDocumentWorkStatistics,
  UIDocumentKindResolver,
  UINativeDocumentKindResolver,
  DocumentKindsFormViewModelMapper,
  DocumentKindsFormViewModel,
  GlobalDocumentKindDto,
  DocumentKindSetHolder,
  Controls,
  Disposable,
  cxDBTL,
  SysUtils,
  Classes;

type

  IDocumentKindsPanelController = interface

  end;

  TDocumentKindsPanelController = class (TInterfacedObject, IDocumentKindsPanelController)

    protected

      FUIDocumentKindResolver: IUIDocumentKindResolver;
      FUINativeDocumentKindResolver: IUINativeDocumentKindResolver;
      FDocumentKindsFormViewModelMapper: TDocumentKindsFormViewModelMapper;

    private

      procedure SetDocumentKindSectionName(
        DocumentKindSetHolder: TDocumentKindSetHolder;
        const DocumentKindId: Variant;
        const NewDocumentKindSectionName: String
      );
      
    public

      destructor Destroy; override;
      
      constructor Create(
        UIDocumentKindResolver: IUIDocumentKindResolver;
        UINativeDocumentKindResolver: IUINativeDocumentKindResolver;
        DocumentKindsFormViewModelMapper: TDocumentKindsFormViewModelMapper
      );

      procedure SetEmployeeDocumentWorkStatistics(
        DocumentKindsFrame: TWinControl;
        EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
      );

      procedure ShowLoadingEmployeeDocumentWorkStatisticsLabel(
        DocumentKindsFrame: TWinControl;
        const LoadingStatisticsLabel: String
      );

      procedure ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
        DocumentKindsFrame: TWinControl;
        DocumentKind: TUIDocumentKindClass;
        const LoadingStatisticsLabel: String
      );

    public

      procedure FillDocumentKindsControlFrom(
        DocumentKindsFrame: TWinControl;
        GlobalDocumentKindDtos: TGlobalDocumentKindDtos
      );
      
    public

      property UIDocumentKindResolver: IUIDocumentKindResolver
      read FUIDocumentKindResolver write FUIDocumentKindResolver;

      property UINativeDocumentKindResolver: IUINativeDocumentKindResolver
      read FUINativeDocumentKindResolver write FUINativeDocumentKindResolver;
      
  end;
  
implementation

uses

  Variants,
  cxTL,
  unDocumentKindsFrame;

{ TDocumentKindsPanelController }

constructor TDocumentKindsPanelController.Create(
  UIDocumentKindResolver: IUIDocumentKindResolver;
  UINativeDocumentKindResolver: IUINativeDocumentKindResolver;
  DocumentKindsFormViewModelMapper: TDocumentKindsFormViewModelMapper
);
begin

  inherited Create;

  FUIDocumentKindResolver := UIDocumentKindResolver;
  FUINativeDocumentKindResolver := UINativeDocumentKindResolver;
  FDocumentKindsFormViewModelMapper := DocumentKindsFormViewModelMapper;

end;

destructor TDocumentKindsPanelController.Destroy;
begin

  FreeAndNil(FDocumentKindsFormViewModelMapper);
  
  inherited;

end;

procedure TDocumentKindsPanelController.FillDocumentKindsControlFrom(
  DocumentKindsFrame: TWinControl;
  GlobalDocumentKindDtos: TGlobalDocumentKindDtos
);
begin

  with DocumentKindsFrame as TDocumentKindsFrame do begin

    ViewModel :=
      FDocumentKindsFormViewModelMapper.MapDocumentKindsFormViewModelFrom(
        GlobalDocumentKindDtos
      );

  end;

end;

procedure TDocumentKindsPanelController.SetDocumentKindSectionName(
  DocumentKindSetHolder: TDocumentKindSetHolder;
  const DocumentKindId: Variant;
  const NewDocumentKindSectionName: String
);
var
    PreviousRecordPointer: Pointer;
begin

  PreviousRecordPointer := nil;

  DocumentKindSetHolder.DisableControls;

  try

    if DocumentKindSetHolder.DocumentKindIdFieldValue <> DocumentKindId then begin

      PreviousRecordPointer := DocumentKindSetHolder.GetBookmark;

      DocumentKindSetHolder.LocateByDocumentKindId(DocumentKindId);

    end;

    DocumentKindSetHolder.DocumentKindNameFieldValue := NewDocumentKindSectionName;

  finally

    try

      DocumentKindSetHolder.GotoBookmarkAndFree(PreviousRecordPointer);

    finally

      DocumentKindSetHolder.EnableControls;

    end;

  end;

end;

procedure TDocumentKindsPanelController.SetEmployeeDocumentWorkStatistics(
  DocumentKindsFrame: TWinControl;
  EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
);
var
    EmployeeDocumentKindWorkStatistics: TEmployeeDocumentKindWorkStatistics;
    DocumentKindTreeNode: TcxDBTreeListNode;
begin

  with DocumentKindsFrame as TDocumentKindsFrame do begin

    for

        EmployeeDocumentKindWorkStatistics in
        EmployeeDocumentWorkStatisticsList

    do begin

      DocumentKindTreeNode :=
        DocumentKindTreeList.FindNodeByKeyValue(
          FUIDocumentKindResolver.ResolveIdForUIDocumentKind(
            FUINativeDocumentKindResolver.ResolveUIDocumentKindFromId(
              EmployeeDocumentKindWorkStatistics.DocumentKindId
            )
          )
        );

      if (EmployeeDocumentKindWorkStatistics.OwnActionDocumentCount = 0) and
           (EmployeeDocumentKindWorkStatistics.InWorkingDocumentCount = 0)
      then begin

          SetDocumentKindSectionName(
            ViewModel.DocumentKindSetHolder,
            DocumentKindTreeNode.KeyValue,
            DocumentKindTreeNode.Values[DocumentKindOriginalNameColumn.ItemIndex]
          );

      end

      else if EmployeeDocumentKindWorkStatistics.InWorkingDocumentCount = 0
      then begin

        SetDocumentKindSectionName(
          ViewModel.DocumentKindSetHolder,
          DocumentKindTreeNode.KeyValue,
          DocumentKindTreeNode.Values[
            DocumentKindOriginalNameColumn.ItemIndex
          ] + ' (' +
          IntToStr(EmployeeDocumentKindWorkStatistics.OwnActionDocumentCount) +
          ')'
        );

      end

      else begin

          SetDocumentKindSectionName(
            ViewModel.DocumentKindSetHolder,
            DocumentKindTreeNode.KeyValue,

            DocumentKindTreeNode.Values[
              DocumentKindOriginalNameColumn.ItemIndex
            ] +
            ' (' +
            IntToStr(EmployeeDocumentKindWorkStatistics.OwnActionDocumentCount) +
            '/' +
            IntToStr(EmployeeDocumentKindWorkStatistics.InWorkingDocumentCount) +
            ')'
          );

      end;

    end;

  end;

end;

procedure TDocumentKindsPanelController.
  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentKindsFrame: TWinControl;
    DocumentKind: TUIDocumentKindClass;
    const LoadingStatisticsLabel: String
  );
var
    DocumentKindTreeNode: TcxDBTreeListNode;
    DocumentKindId: Variant;
begin

  with DocumentKindsFrame as TDocumentKindsFrame do begin

    DocumentKindId := FUIDocumentKindResolver.ResolveIdForUIDocumentKind(DocumentKind);
    
    DocumentKindTreeNode := DocumentKindTreeList.FindNodeByKeyValue(DocumentKindId);

    if not Assigned(DocumentKindTreeNode) then begin

      raise Exception.CreateFmt(
        'Не найден раздел для вида документов ' +
        'с идентификатором %s',
        [VarToStr(DocumentKindId)]
      );

    end;

    SetDocumentKindSectionName(
      ViewModel.DocumentKindSetHolder,
      DocumentKindTreeNode.KeyValue,
        
      DocumentKindTreeNode.Values[DocumentKindOriginalNameColumn.ItemIndex] +
        ' ' + LoadingStatisticsLabel
    );

  end;

end;

procedure TDocumentKindsPanelController.
  ShowLoadingEmployeeDocumentWorkStatisticsLabel(
    DocumentKindsFrame: TWinControl;
    const LoadingStatisticsLabel: String
  );
begin

  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentKindsFrame,
    TUIOutcomingServiceNoteKind,
    LoadingStatisticsLabel
  );

  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentKindsFrame,
    TUIIncomingServiceNoteKind,
    LoadingStatisticsLabel
  );

  ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
    DocumentKindsFrame,
    TUIApproveableServiceNoteKind,
    LoadingStatisticsLabel
  );
  
end;

end.
