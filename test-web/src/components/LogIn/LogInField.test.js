import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import { MemoryRouter } from 'react-router-dom'; // MemoryRouter 추가
import LogInField from './LogInField';
import { UserProvider } from '../../shared/Utils/UserContext';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';

// Firebase Mock 처리
jest.mock('firebase/auth', () => ({
  getAuth: jest.fn(() => ({
    currentUser: null,
  })),
  signInWithEmailAndPassword: jest.fn(() =>
    Promise.resolve({ user: { email: 'test@example.com' } })
  ),
}));

jest.mock('firebase/app', () => ({
  initializeApp: jest.fn(),
}));

// React Router Mock
const mockNavigate = jest.fn(); // mockNavigate 선언
jest.mock('react-router-dom', () => ({
  ...jest.requireActual('react-router-dom'), // React Router의 다른 기능 유지
  useNavigate: () => mockNavigate, // useNavigate를 mockNavigate로 대체
}));

const renderWithProviders = (ui) => {
  return render(
    <MemoryRouter>
      <UserProvider>{ui}</UserProvider>
    </MemoryRouter>
  );
};

test('renders LogInField component correctly', () => {
  renderWithProviders(<LogInField />);

  // 제목 확인
  expect(screen.getByText(/login/i)).toBeInTheDocument();

  // 이메일 입력 필드 확인
  expect(
    screen.getByPlaceholderText('이메일을 입력하세요.')
  ).toBeInTheDocument();

  // 비밀번호 입력 필드 확인
  expect(
    screen.getByPlaceholderText('비밀번호를 입력하세요.')
  ).toBeInTheDocument();

  // 로그인 버튼 확인
  expect(screen.getByRole('button', { name: /로그인/i })).toBeInTheDocument();
});

test('handles user input in email and password fields', () => {
  renderWithProviders(<LogInField />);

  // 이메일 입력 필드
  const emailInput = screen.getByPlaceholderText('이메일을 입력하세요.');
  fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
  expect(emailInput.value).toBe('test@example.com');

  // 비밀번호 입력 필드
  const passwordInput = screen.getByPlaceholderText('비밀번호를 입력하세요.');
  fireEvent.change(passwordInput, { target: { value: 'password123' } });
  expect(passwordInput.value).toBe('password123');
});

test('toggles Remember Me checkbox', () => {
  renderWithProviders(<LogInField />);

  const checkbox = screen.getByRole('checkbox', { name: /아이디 저장/i });

  // 기본 상태 확인 (unchecked)
  expect(checkbox).not.toBeChecked();

  // 클릭하여 체크 상태 변경
  fireEvent.click(checkbox);
  expect(checkbox).toBeChecked();

  // 다시 클릭하여 체크 해제
  fireEvent.click(checkbox);
  expect(checkbox).not.toBeChecked();
});

test('displays error message when fields are empty', async () => {
  renderWithProviders(<LogInField />);

  const loginButton = screen.getByRole('button', { name: /로그인/i });

  // 로그인 버튼 클릭 (이메일과 비밀번호 입력 없음)
  fireEvent.click(loginButton);

  // 에러 메시지 확인
  expect(await screen.findByText('아이디를 입력해주세요.')).toBeInTheDocument();
});

test('shows error message when email is empty', async () => {
  renderWithProviders(<LogInField />);

  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));

  expect(await screen.findByText('아이디를 입력해주세요.')).toBeInTheDocument();
});

test('shows error message when password is empty', async () => {
  renderWithProviders(<LogInField />);

  fireEvent.change(screen.getByPlaceholderText('이메일을 입력하세요.'), {
    target: { value: 'test@example.com' },
  });
  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));

  expect(
    await screen.findByText('비밀번호를 입력해주세요.')
  ).toBeInTheDocument();
});

test('shows error when user lacks permission', async () => {
  // userIsLogin Mock 응답 설정
  global.fetch = jest.fn(() =>
    Promise.resolve({
      json: () =>
        Promise.resolve({
          userId: 'test@example.com',
          name: 'John Doe',
          homeaddr: '123 Main St',
          company: 'DeepPlant',
          jobTitle: 'Engineer',
          type: 'Normal', // 관리자 계정
          alarm: true,
          createdAt: '2024-01-01T00:00:00Z',
        }),
    })
  );
  renderWithProviders(<LogInField />);

  fireEvent.change(screen.getByPlaceholderText('이메일을 입력하세요.'), {
    target: { value: 'test@example.com' },
  });
  fireEvent.change(screen.getByPlaceholderText('비밀번호를 입력하세요.'), {
    target: { value: 'password123' },
  });
  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));

  expect(
    await screen.findByText('로그인 권한이 없습니다. 관리자에게 문의해주세요.')
  ).toBeInTheDocument();
});

beforeEach(() => {
  mockNavigate.mockClear(); // 매 테스트 실행 전에 mockNavigate 초기화
});

test('calls login function with correct credentials', async () => {
  // console.log Spy
  const consoleSpy = jest.spyOn(console, 'log');

  // userIsLogin Mock 응답 설정
  global.fetch = jest.fn(() =>
    Promise.resolve({
      json: () =>
        Promise.resolve({
          userId: 'test@example.com',
          name: 'John Doe',
          homeaddr: '123 Main St',
          company: 'DeepPlant',
          jobTitle: 'Engineer',
          type: 'Admin', // 관리자 계정
          alarm: true,
          createdAt: '2024-01-01T00:00:00Z',
        }),
    })
  );

  renderWithProviders(<LogInField />);

  // 입력 필드에 값 설정
  fireEvent.change(screen.getByPlaceholderText('이메일을 입력하세요.'), {
    target: { value: 'test@example.com' },
  });
  fireEvent.change(screen.getByPlaceholderText('비밀번호를 입력하세요.'), {
    target: { value: 'password123' },
  });

  // 로그인 버튼 클릭
  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));
  expect(global.fetch).toHaveBeenCalledTimes(1);
  expect(global.fetch).toHaveBeenCalledWith(
    expect.stringContaining('test@example.com')
  );
  await waitFor(() => {
    expect(signInWithEmailAndPassword).toHaveBeenCalledTimes(1);
  }); // 성공적인 로그인 확인 (console.log)
  await waitFor(() => {
    expect(consoleSpy).toHaveBeenCalledWith('LOGIN SUCCESS');
  });

  // navigate 호출 확인
  console.log('mockNavigate calls:', mockNavigate.mock.calls); // 호출 기록 확인
  expect(mockNavigate).toHaveBeenCalledWith('/Home');

  // Cleanup
  consoleSpy.mockRestore();
});

test('shows error when user ID does not exist', async () => {
  // Firebase signInWithEmailAndPassword Mock - 사용자 ID 없음
  global.fetch = jest.fn(() =>
    Promise.resolve({
      json: () =>
        Promise.resolve({
          userId: 'nobody@example.com',
          name: 'John Doe',
          homeaddr: '123 Main St',
          company: 'DeepPlant',
          jobTitle: 'Engineer',
          type: 'Admin', // 관리자 계정
          alarm: true,
          createdAt: '2024-01-01T00:00:00Z',
        }),
    })
  );
  signInWithEmailAndPassword.mockImplementationOnce(() =>
    Promise.reject({ code: 'auth/user-not-found' })
  );

  renderWithProviders(<LogInField />);

  // 입력 필드에 값 설정
  fireEvent.change(screen.getByPlaceholderText('이메일을 입력하세요.'), {
    target: { value: 'nobody@example.com' },
  });
  fireEvent.change(screen.getByPlaceholderText('비밀번호를 입력하세요.'), {
    target: { value: 'password123' },
  });

  // 로그인 버튼 클릭
  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));

  // 에러 메시지 확인
  expect(
    await screen.findByText('존재하지 않는 아이디입니다.')
  ).toBeInTheDocument();
});

test('shows error when too many login attempts', async () => {
  global.fetch = jest.fn(() =>
    Promise.resolve({
      json: () =>
        Promise.resolve({
          userId: 'nobody@example.com',
          name: 'John Doe',
          homeaddr: '123 Main St',
          company: 'DeepPlant',
          jobTitle: 'Engineer',
          type: 'Admin', // 관리자 계정
          alarm: true,
          createdAt: '2024-01-01T00:00:00Z',
        }),
    })
  );

  // Firebase signInWithEmailAndPassword Mock - 너무 많은 요청
  signInWithEmailAndPassword.mockImplementationOnce(() =>
    Promise.reject({ code: 'auth/too-many-requests' })
  );

  renderWithProviders(<LogInField />);

  // 입력 필드에 값 설정
  fireEvent.change(screen.getByPlaceholderText('이메일을 입력하세요.'), {
    target: { value: 'test@example.com' },
  });
  fireEvent.change(screen.getByPlaceholderText('비밀번호를 입력하세요.'), {
    target: { value: 'password123' },
  });

  // 로그인 버튼 클릭
  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));

  // 에러 메시지 확인
  expect(
    await screen.findByText(
      '로그인을 너무 많이 시도했습니다. 잠시후 다시 시도해주세요.'
    )
  ).toBeInTheDocument();
});

test('shows error when password is incorrect', async () => {
  global.fetch = jest.fn(() =>
    Promise.resolve({
      json: () =>
        Promise.resolve({
          userId: 'nobody@example.com',
          name: 'John Doe',
          homeaddr: '123 Main St',
          company: 'DeepPlant',
          jobTitle: 'Engineer',
          type: 'Admin', // 관리자 계정
          alarm: true,
          createdAt: '2024-01-01T00:00:00Z',
        }),
    })
  );
  // Firebase signInWithEmailAndPassword Mock - 비밀번호가 일치하지 않음
  signInWithEmailAndPassword.mockImplementationOnce(() =>
    Promise.reject({ code: 'auth/wrong-password' })
  );

  renderWithProviders(<LogInField />);

  // 입력 필드에 값 설정
  fireEvent.change(screen.getByPlaceholderText('이메일을 입력하세요.'), {
    target: { value: 'test@example.com' },
  });
  fireEvent.change(screen.getByPlaceholderText('비밀번호를 입력하세요.'), {
    target: { value: 'wrongpassword' },
  });

  // 로그인 버튼 클릭
  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));

  // 에러 메시지 확인
  expect(
    await screen.findByText('비밀번호가 일치하지 않습니다.')
  ).toBeInTheDocument();
});

test('shows error when login fails for other reasons', async () => {
  global.fetch = jest.fn(() =>
    Promise.resolve({
      json: () =>
        Promise.resolve({
          userId: 'nobody@example.com',
          name: 'John Doe',
          homeaddr: '123 Main St',
          company: 'DeepPlant',
          jobTitle: 'Engineer',
          type: 'Admin', // 관리자 계정
          alarm: true,
          createdAt: '2024-01-01T00:00:00Z',
        }),
    })
  );
  // Firebase signInWithEmailAndPassword Mock - 기타 오류
  signInWithEmailAndPassword.mockImplementationOnce(() =>
    Promise.reject({ message: 'Unexpected error occurred' })
  );

  renderWithProviders(<LogInField />);

  // 입력 필드에 값 설정
  fireEvent.change(screen.getByPlaceholderText('이메일을 입력하세요.'), {
    target: { value: 'test@example.com' },
  });
  fireEvent.change(screen.getByPlaceholderText('비밀번호를 입력하세요.'), {
    target: { value: 'password123' },
  });

  // 로그인 버튼 클릭
  fireEvent.click(screen.getByRole('button', { name: /로그인/i }));

  // 에러 메시지 확인
  expect(
    await screen.findByText('로그인에 실패했습니다. 관리자에게 문의해주세요.')
  ).toBeInTheDocument();
});
