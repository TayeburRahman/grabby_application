import './index.css'
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider } from 'react-router-dom'
import { router } from './router/routes'
import { ThemeProvider } from './theme/theme-provider'
import { Toaster } from './components/ui/sonner'
// import { Provider } from 'react-redux'
// import { store } from './redux/store'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    {/* <Provider store={store}> */}
      <ThemeProvider defaultTheme='light' storageKey='theme'>
          <RouterProvider router={router} />
          <Toaster richColors position="bottom-right" />
      </ThemeProvider>
    {/* </Provider> */}
  </StrictMode>,
)